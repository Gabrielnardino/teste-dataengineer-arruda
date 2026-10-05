.PHONY: up clean ingest test-bronze

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
