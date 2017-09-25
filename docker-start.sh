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
    if [ ! -f /.ssh_key_set ]; then
        if [ -f /etc/ssh/ssh_host_rsa_key ]; then
            rm -f /etc/ssh/ssh_host_rsa_key
        fi
        if [ -f /etc/ssh/ssh_host_dsa_key ]; then
            rm -f /etc/ssh/ssh_host_dsa_key
        fi
        ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
        ssh-keygen -t rsa -f /etc/ssh/ssh_host_dsa_key -N ''
        touch /.ssh_key_set 2>/dev/null
    fi
}

__change_pass() {
    if [ ! -f /.user_pw_set ]; then
        echo -e "$SSH_USERPASS" | (passwd --stdin $SSH_USERNAME) 2>/dev/null
        touch /.user_pw_set 2>/dev/null
        echo "========================================================================"
        echo -e "                         部署完成"
        echo ""
        echo -e "                  用户名称: $SSH_USERNAME"
        echo -e "                  用户密码: $SSH_USERPASS"
        echo ""
        echo -e "            警告: 初次登陆后, 记得修改密码!!!"
        echo "========================================================================"
    fi
}

# Call all functions
__create_rundir
__create_hostkeys
__change_pass

exec "$@"
