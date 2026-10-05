SHELL := /bin/bash
.SHELLFLAGS := -eo pipefail -c

DBT := docker compose run --rm --user $$(id -u):$$(id -g) dbt
LOG = logs/$@.log

etapa = @printf '\n\033[1m==> %s\033[0m\n' "$(1)"
run = @mkdir -p logs; $(1) > $(LOG) 2>&1 || { tail -n 40 $(LOG); printf '\nFalhou. Log completo em %s\n' $(LOG); exit 1; }
resumo_dbt = @grep -h "Done\." $(LOG) | sed 's/.*Done\. /    /'; grep -hE " WARN [0-9]+ " $(LOG) | sed -E 's/.* WARN ([0-9]+) ([^ ]+).*/    aviso: \2 (\1 resultados)/' || true

.PHONY: all up clean ingest test-bronze test-sources transform docs docs-serve sql

all: ingest test-bronze test-sources transform docs
	@printf '\nPronto. Ver os dados: make sql | Documentação: make docs-serve | Logs: logs/\n'

# origem é o repositório oficial como submódulo; garante que veio no clone
source/docker-compose.yml:
	git submodule update --init

up: source/docker-compose.yml
	$(call etapa,Subindo os bancos de origem e destino)
	$(call run,docker compose up -d --wait db dw)
	@echo "    ok"

# derruba tudo e apaga os volumes: o próximo `up` recria os bancos do zero
clean:
	docker compose down -v

ingest: up
	$(call etapa,Ingestão da bronze com Apache Hop)
	$(call run,docker compose run --rm hop)
	@grep -h "bronze_load - Pipeline duration" $(LOG) | sed -E 's/.*: ([0-9.]+) seconds.*/    ok em \1s/'

test-bronze:
	$(call etapa,Testando a bronze contra a origem)
	@./tests/test_bronze.sh | sed 's/^/    /'

test-sources:
	$(call etapa,Testes das sources com dbt)
	$(call run,$(DBT) test --select "source:*" --indirect-selection cautious)
	$(resumo_dbt)

transform:
	$(call etapa,Transformação silver e gold com dbt build)
	$(call run,$(DBT) build --select silver gold)
	$(resumo_dbt)

docs:
	$(call etapa,Documentação com dbt docs generate)
	$(call run,$(DBT) docs generate)
	@echo "    ok"

docs-serve:
	docker compose run --rm --user $$(id -u):$$(id -g) --service-ports dbt docs serve --host 0.0.0.0 --port 8080

sql:
	docker compose exec dw psql -U postgres -d dw
