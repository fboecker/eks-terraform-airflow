FROM python:alpine

ARG CLI_VERSION=1.18.121

RUN apk -uv add --no-cache groff jq less make bash && \
    pip install --no-cache-dir awscli==$CLI_VERSION

RUN apk add --update --no-cache curl ca-certificates && \
    curl -L https://get.helm.sh/helm-v3.3.0-linux-amd64.tar.gz | tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64 && \
    apk del curl && \
    rm -f /var/cache/apk/*

ENV KUBE_LATEST_VERSION="v1.18.0"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

WORKDIR /aws

CMD sh
