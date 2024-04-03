FROM alpine:3.19

RUN apk add --no-cache openssh-server tini

WORKDIR /data

RUN mkdir -p /data/etc/ssh/
COPY files/sshd_config /data/etc/ssh/sshd_config
RUN mv /etc/shadow /data/etc/shadow && ln -s /data/etc/shadow /etc/shadow
RUN mv /etc/passwd /data/etc/passwd && ln -s /data/etc/passwd /etc/passwd
RUN mv /home /data && ln -s /data/home /home

COPY bin /usr/bin

ENV SSH_USER=user
EXPOSE 22
VOLUME [ "/data" ]

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
