FROM alpine:3.10.3

LABEL "com.github.actions.name"="Delete pull request label branch"
LABEL "com.github.actions.description"="Delete pull requests branch based on label"
LABEL "com.github.actions.icon"="tag"
LABEL "com.github.actions.color"="blue"

LABEL maintainer="Manish Rathi <manishrathi19902013@gmail.com>"

RUN apk add --no-cache bash curl jq

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
