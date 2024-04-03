#!/bin/sh

/usr/bin/ssh-keygen -A -f /data

# check if sudo user exists and create it if not

if ! id ${SSH_USER} > /dev/null; then
	echo "Creating ${SSH_USER} with random password"
  adduser ${SSH_USER}
	RND=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
	echo ${SSH_USER}:$RND | chpasswd
	echo "Temporary password for ${SSH_USER} :: $RND"
	echo
fi

exec /sbin/tini -- /usr/sbin/sshd -D -f /data/etc/ssh/sshd_config
