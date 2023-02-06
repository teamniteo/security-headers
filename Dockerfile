FROM alpine:3.17

RUN apk add --update coreutils jq bash curl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
