FROM alpine:3.11.3

COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

RUN apk --no-cache add openvpn gnupg

ENTRYPOINT ["/entrypoint.sh"]
