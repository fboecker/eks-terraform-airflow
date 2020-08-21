include ../common.mk
include ../apps.mk


.PHONY: deploy
deploy: \
    add-repo \
    deploy-nginxingress

.PHONY: add-repo
add-repo:
	helm repo add stable  https://kubernetes-charts.storage.googleapis.com/


.PHONY: deploy-nginxingress
deploy-nginxingress:
	helm upgrade -i nginx-ingress \
	     --namespace kube-system \
	     --version $(NGINXINGRESS_CHART_VERSION) \
	     -f values.nginxingress.yaml \
	     stable/nginx-ingress
