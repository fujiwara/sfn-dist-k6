K6_VERSION ?= v0.44.1
export AWS_ACCOUNT_ID ?= $(shell aws sts get-caller-identity --query Account --output text)

.PHONY: help clean

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  clean          to clean up"
	@echo "  k6             to install k6"
	@echo "  deploy-dry-run to deploy lambda function(dry-run)"
	@echo "  deploy         to deploy lambda function"

clean:
	rm -rf k6 k6-$(K6_VERSION)-linux-amd64*

k6:
	wget https://github.com/grafana/k6/releases/download/$(K6_VERSION)/k6-$(K6_VERSION)-linux-amd64.tar.gz
	tar xvf k6-$(K6_VERSION)-linux-amd64.tar.gz
	install k6-$(K6_VERSION)-linux-amd64/k6 ./
	rm -rf k6-$(K6_VERSION)-linux-amd64*

deploy-dry-run: k6
	lambroll deploy --dry-run

deploy: k6
	lambroll deploy

statemachine.json:
	jq -n env > env.json
	jsonnet statemachine.jsonnet
