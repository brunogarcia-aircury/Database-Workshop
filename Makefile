#Load environment variables
include .env
export $(shell sed 's/=.*//' .env)

# Optionally load .env.local if it exists
ifneq ("$(wildcard .env.local)","")
  include .env.local
  export $(shell sed 's/=.*//' .env.local)
endif

.PHONY:

docker=docker compose
ENV_ARGS=--env-file=.env --env-file=.env.local

-include Makefile.local

up:
	$(eval args := $(filter-out $@,$(MAKECMDGOALS)))
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) up -d $(args) || $(docker) up -d $(args)

connect:
	make up
	@.config/docker/connect.sh

console:
	make up
	docker exec -it "$$CONTAINER_NAME-console" python .config/docker/console/console.py

down:
	$(eval args := $(filter-out $@,$(MAKECMDGOALS)))
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) down $(args) || $(docker) down $(args)

%:
	@: