.PHONY:

docker=docker compose
ENV_ARGS=--env-file=.env --env-file=.env.local

-include Makefile.local

up:
	$(eval args := $(filter-out $@,$(MAKECMDGOALS)))
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) up -d $(args) || $(docker) up -d $(args)

build:
	$(eval args := $(filter-out $@,$(MAKECMDGOALS)))
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) build $(args) || $(docker) build $(args)

psql:
	$(eval args := $(filter-out $@,$(MAKECMDGOALS)))
	@.config/docker/run.sh $(args)

init:
	make down
	make up
	make build
	docker exec "workshop-db-python-env" python .config/docker/python/init.py
	make psql "/imports/unzip/airport/zip/postgres_air_2024.sql/postgres_air_2024.sql"
	make psql "/imports/sql/custom_field.sql"

stop:
	$(eval args := $(filter-out $@,$(MAKECMDGOALS)))
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) stop $(args) || $(docker) stop $(args)

down:
	$(eval args := $(filter-out $@,$(MAKECMDGOALS)))
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) down $(args) || $(docker) down $(args)

clean:
	@find .config/temp -mindepth 1 ! -path .config/temp/.gitignore -exec rm -rf {} +

help:
	@echo "Available commands:"
	@echo "  make up [service_name]    - Start specified docker container, by default it start all docker containers."
	@echo "  make build [service_name] - Build specified docker container, by default it build all docker containers."
	@echo "  make psql [file]          - Open a PostgreSQL console or run all sql queries inside the specified file path"
	@echo "  make init                 - Initialize the database"
	@echo "  make down                 - Stop and remove containers"
	@echo "  make clean                - Clean up temporary files"

%:
	@: