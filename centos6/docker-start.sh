#!/bin/bash

: ${SSH_USERNAME:=user}
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
        if [ -f /etc/ssh/ssh_host_dsa_key]; then
            rm -f /etc/ssh/ssh_host_dsa_key
        fi
        ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
        ssh-keygen -t rsa -f /etc/ssh/ssh_host_dsa_key -N ''
        touch /.ssh_key_set
    fi
}

__create_user() {
    if [ ! -f /.user_pw_set ]; then
        useradd $SSH_USERNAME
        echo -e "$SSH_USERPASS" | (passwd --stdin $SSH_USERNAME)
        touch /.user_pw_set
        echo "========================================================================"
        echo "You can now connect to this CentOS container via SSH using:"
        echo ""
        echo "and enter the '$SSH_USERNAME' password '$SSH_USERPASS' when prompted"
        echo ""
        echo "Please remember to change the above password as soon as possible!"
        echo "========================================================================"
    fi
}

# Call all functions
__create_rundir
__create_hostkeys
__create_user

exec "$@"
