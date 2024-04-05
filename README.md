# docker-ssh-bastion

Simple container to act as an [SSH bastion](https://en.wikipedia.org/wiki/Bastion_host).

```
$ docker run -d \
             --name test-ssh-bastion \
             --volume test-ssh-bastion-data:/data \
             -p22221:22 \
             ghcr.io/fopina/ssh-bastion:latest

$ docker logs test-ssh-bastion | grep password
Creating user with random password
chpasswd: password for 'user' changed
Temporary password for user :: wF39B0KgwvPxOEOLNzxC

$ ssh -l user localhost -p 22221
(user@localhost) Password:
Welcome to Alpine!
e6f93a820b48:~$
```

## Configuration

* Users in `wheel` group can `sudo` without password
* google-authenticatior is installed to allow 2FA to be setup
* `/home` and some configuration files are persisted in `/data` volume

### Environment Variables

| Name | Default | Description |
| ---- | ------- | ----------- |
| SSH_USER | user | Username to be created.<br>It is added to `wheel` group and can sudo without password.<br>Random password assign and printed to logs, if the user did not already exist |

### Volumes

`/data` is the only volume:
* User home directories are set to `/data/home/$USER`
* [pam-sshd](files/pam-sshd) is there so google-authenticator settings can be customized - such as removing `nullok` or increasing `grace_period`
* [sshd_config](files/sshd_config) in case of any sshd customization is required - such as allow root to login
* `/etc/passwd`, `/etc/shadow`, `/etc/group` link to files there as well to persist the added groups and users
