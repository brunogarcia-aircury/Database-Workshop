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

down:
	$(eval args := $(filter-out $@,$(MAKECMDGOALS)))
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) down $(args) || $(docker) down $(args)

%:
	@: