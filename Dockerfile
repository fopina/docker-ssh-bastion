FROM alpine:3.19

RUN apk add --no-cache openssh-server-pam \
                       google-authenticator \
                       tini \
                       sudo \
                       bash

WORKDIR /data

RUN mkdir -p /data/etc/ssh/
RUN mkdir -p /data/etc/pam.d/
COPY files/sudoers /etc/sudoers.d/ssh-bastion
COPY files/pam-sshd /data/etc/pam.d/sshd
COPY files/sshd_config /data/etc/ssh/sshd_config
RUN mv /etc/shadow /data/etc/shadow && ln -s /data/etc/shadow /etc/shadow
RUN mv /etc/passwd /data/etc/passwd && ln -s /data/etc/passwd /etc/passwd
RUN mv /etc/group /data/etc/group && ln -s /data/etc/group /etc/group
RUN rm /etc/pam.d/sshd && ln -s /data/etc/pam.d/sshd /etc/pam.d/sshd
RUN mv /home /data && ln -s /data/home /home

COPY bin /usr/bin

ENV SSH_USER=user
EXPOSE 22
VOLUME [ "/data" ]

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
