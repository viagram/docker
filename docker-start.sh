#!/bin/bash

: ${SSH_USERNAME:=root}
: ${SSH_USERPASS:=$(cat /proc/sys/kernel/random/uuid | sha256sum | base64 | head -c 15;echo)}
#: ${SSH_USERPASS:=$(dd if=/dev/urandom bs=1 count=15 | base64)}

__create_rundir() {
	if [ ! -d "/var/run/sshd" ]; then
		mkdir -p /var/run/sshd
	fi
}
__create_hostkeys() {
	if [[ ! -f /.ssh_key_set ]]; then
		if [[ -f /etc/ssh/ssh_host_ed25519_key ]]; then
			rm -f /etc/ssh/ssh_host_ed25519_key
		fi
		if [[ -f /etc/ssh/ssh_host_ed25519_key.pub ]]; then
			rm -f /etc/ssh/ssh_host_ed25519_key.pub
		fi
		(sleep 1;echo "y") | ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N ""
		chmod 620 /etc/ssh/moduli >/dev/null 2>&1
		chmod 644 /etc/ssh/ssh_config /etc/ssh/*.pub >/dev/null 2>&1
		chmod 600 /etc/ssh/sshd_config /etc/ssh/*_key >/dev/null 2>&1
		touch /.ssh_key_set >/dev/null 2>&1
	fi
}

__change_pass() {
	if [ ! -f /.user_pw_set ]; then
		echo -e "$SSH_USERPASS" | (passwd --stdin $SSH_USERNAME) >/dev/null 2>&1
		touch /.user_pw_set >/dev/null 2>&1
		echo "========================================================================"
		echo -e "		部署完成"
		echo 
		echo -e "		用户名称: $SSH_USERNAME"
		echo -e "		用户密码: $SSH_USERPASS"
		echo 
		echo -e "		警告: 初次登陆后, 记得修改密码!!!"
		echo "========================================================================"
	fi
}

# Call all functions
__create_rundir
__create_hostkeys
__change_pass

exec "$@"
