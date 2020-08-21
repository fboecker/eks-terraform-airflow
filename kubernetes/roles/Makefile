include ../common.mk

.PHONY: deploy
deploy: create-role

.PHONY: create-role
create-role:
	kubectl apply -f ./configmap.yaml -n kube-system
