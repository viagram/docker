#!/bin/sh

yum -y install bzip2-devel libxml2-devel curl-devel db4-devel libjpeg-devel libpng-devel freetype-devel pcre-devel zlib-devel sqlite-devel libmcrypt-devel 
yum -y install mhash-devel openssl-devel unzip
yum -y install libtool-ltdl libtool-ltdl-devel
PREFIX="/vhs/kangle/ext/php55"
ZEND_ARCH="i386"
LIB="lib"
if test `arch` = "x86_64"; then
        LIB="lib64"
        ZEND_ARCH="x86_64"
fi

[  -z $1 ] && DOWNLOAD_PHP_URL="http://d.zuzb.com/web" || DOWNLOAD_PHP_URL=$1

wget -c http://hk1.php.net/get/php-5.5.28.tar.gz/from/this/mirror -O php-5.5.28.tar.gz
tar zxvf php-5.5.28.tar.gz
cd php-5.5.28
CONFIG_CMD="./configure --prefix=$PREFIX --with-config-file-scan-dir=$PREFIX/etc/php.d --with-libdir=$LIB --enable-fastcgi --with-mysql --with-mysqli --with-pdo-mysql --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr/include/libxml2/libxml --enable-xml --disable-fileinfo --enable-magic-quotes --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-mbstring --enable-ftp --with-gd --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --with-pear --with-gettext --enable-calendar --with-openssl"
if [ -f /usr/include/mcrypt.h ]; then
        CONFIG_CMD="$CONFIG_CMD --with-mcrypt"
fi
#'./configure' --prefix=$PREFIX --with-config-file-scan-dir=$PREFIX/etc/php.d --with-libdir=$LIB '--enable-fastcgi' '--with-mysql' '--with-mysqli' --with-pdo-mysql '--with-iconv-dir' '--with-freetype-dir' '--with-jpeg-dir' '--with-png-dir' '--with-zlib' '--with-libxml-dir=/usr/include/libxml2/libxml' '--enable-xml' '--disable-fileinfo' '--enable-magic-quotes' '--enable-safe-mode' '--enable-bcmath' '--enable-shmop' '--enable-sysvsem' '--enable-inline-optimization' '--with-curl' '--with-curlwrappers' '--enable-mbregex' '--enable-mbstring' '--enable-ftp' '--with-gd' '--enable-gd-native-ttf' '--with-openssl' '--enable-pcntl' '--enable-sockets' '--with-xmlrpc' '--enable-zip' '--enable-soap' '--with-pear' '--with-gettext' '--enable-calendar'
#'./configure' --prefix=$PREFIX --with-config-file-scan-dir=$PREFIX/etc/php.d --with-libdir=$LIB '--enable-fastcgi' '--with-mysql' '--with-mysqli' --with-pdo-mysql '--with-iconv-dir' '--with-freetype-dir' '--with-jpeg-dir' '--with-png-dir' '--with-zlib' '--with-libxml-dir=/usr/include/libxml2/libxml' '--enable-xml' '--disable-fileinfo' '--enable-magic-quotes' '--enable-safe-mode' '--enable-bcmath' '--enable-shmop' '--enable-sysvsem' '--enable-inline-optimization' '--with-curl' '--with-curlwrappers' '--enable-mbregex' '--enable-mbstring' '--with-mcrypt' '--enable-ftp' '--with-gd' '--enable-gd-native-ttf' '--with-openssl' '--with-mhash' '--enable-pcntl' '--enable-sockets' '--with-xmlrpc' '--enable-zip' '--enable-soap' '--with-pear' '--with-gettext' '--enable-calendar'
$CONFIG_CMD
if test $? != 0; then
	echo $CONFIG_CMD
	echo "configure php error";
	exit 1
fi
make
make install
mkdir -p $PREFIX/etc/php.d
if [ ! -f $PREFIX/php-templete.ini ]; then
        cp php.ini-dist $PREFIX/php-templete.ini
fi
if [ ! -f $PREFIX/config.xml ]; then
        wget $DOWNLOAD_PHP_URL/php55/config.xml -O $PREFIX/config.xml
fi
cd ..
wget $DOWNLOAD_PHP_URL/php55/php-templete.ini -O $PREFIX/php-templete.ini
#install ioncube
wget -c https://raw.githubusercontent.com/1265578519/kangle/master/php/5.5/5527/ioncube-$ZEND_ARCH-5.5.zip
unzip ioncube-$ZEND_ARCH-5.5.zip
mkdir -p $PREFIX/ioncube
\mv ioncube_loader_lin_5.5.so $PREFIX/ioncube/ioncube_loader_lin_5.5.so
wget http://pecl.php.net/get/memcache-3.0.8.tgz
tar zxf memcache-3.0.8.tgz
cd memcache-3.0.8
$PREFIX/bin/phpize
./configure --with-php-config=$PREFIX/bin/php-config
make
make install
# wget http://pecl.php.net/get/apcu-4.0.7.tgz
# tar zxf apcu-4.0.7.tgz
# cd apcu-4.0.7
# $PREFIX/bin/phpize
# ./configure --with-php-config=$PREFIX/bin/php-config
# make
# make install
rm -rf /tmp/*
/vhs/kangle/bin/kangle -r
cd ..
