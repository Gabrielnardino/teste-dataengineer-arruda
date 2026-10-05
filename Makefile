DBT := docker compose run --rm --user $$(id -u):$$(id -g) dbt

all: ingest test-bronze test-sources transform docs

.PHONY: all up clean ingest test-bronze test-sources transform docs docs-serve

# origem é o repositório oficial como submódulo; garante que veio no clone
source/docker-compose.yml:
	git submodule update --init

up: source/docker-compose.yml
	docker compose up -d --wait db dw

# derruba tudo e apaga os volumes: o próximo `up` recria os bancos do zero
clean:
	docker compose down -v

ingest: up
	docker compose run --rm hop

test-bronze:
	./tests/test_bronze.sh

test-sources:
	$(DBT) test --select "source:*" --indirect-selection cautious

transform:
	$(DBT) build --select silver gold

docs:
	$(DBT) docs generate

docs-serve:
	docker compose run --rm --user $$(id -u):$$(id -g) --service-ports dbt docs serve --host 0.0.0.0 --port 8080
