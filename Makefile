DOCKER_IMAGE_VERSION=1.0
DOCKER_IMAGE_NAME=dataworldliving
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
PORT_IN=8043
PORT_OUT=8043

default: build ## default = build

build: ## build the image
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push: ## push to registry
	docker push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_TAGNAME)

test: ## test the image
	docker run --rm $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."

rmi: ## remove the image
	docker rmi -f $(DOCKER_IMAGE_TAGNAME)

rebuild: rmi build ## rebuild it

run: ## run the image
	docker run -d -p $(PORT_OUT):$(PORT_IN) $(DOCKER_IMAGE_NAME):latest

help: ## This help dialog
	@IFS=$$'\n' ; \
		help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
		for help_line in $${help_lines[@]}; do \
			IFS=$$'#' ; \
			help_split=($$help_line) ; \
			help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			printf "%-10s %s\n" $$help_command $$help_info ; \
		done

.PHONY: help run list build test rmi rebuild push