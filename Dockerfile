FROM alpine:3.11.3

COPY LICENSE README.md registry-config.yml.tmpl /

RUN apk --no-cache add bash gettext git

ADD https://github.com/uber/makisu/releases/download/v0.1.14/makisu-v0.1.14 /usr/local/bin/makisu
ADD https://raw.githubusercontent.com/uber/makisu/master/assets/cacerts.pem /makisu-internal/certs/cacerts.pem
ADD https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.5.4/kustomize_v3.5.4_linux_amd64.tar.gz /tmp/kustomize.tar.gz

RUN chmod u+x /usr/local/bin/makisu && \
  cd /tmp/                          && \
  tar xf /tmp/kustomize.tar.gz      && \
  mv /tmp/kustomize /usr/local/bin

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
