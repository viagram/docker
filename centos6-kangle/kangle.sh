#!/bin/bash
service kangle stop
rm -rf kangle*
yum -y install make automake gcc gcc-c++ pcre-devel zlib-devel sqlite-devel openssl-devel
wget --no-check-certificate https://raw.githubusercontent.com/viagram/docker/master/centos6-kangle/kangle-3.5.8.tar.gz -O kangle-3.5.8.tar.gz
tar xzf kangle-3.5.8.tar.gz
cd kangle-3.5.8
./configure --prefix=/vhs/kangle --enable-disk-cache --enable-ipv6 --enable-ssl --enable-vh-limit
make
make install
service kangle start