#!/bin/sh

yum -y install bzip2-devel libxml2-devel curl-devel db4-devel libjpeg-devel libpng-devel freetype-devel pcre-devel zlib-devel sqlite-devel libmcrypt-devel 
yum -y install mhash-devel openssl-devel unzip
yum -y install libtool-ltdl libtool-ltdl-devel
PREFIX="/vhs/kangle/ext/php54"
ZEND_ARCH="i386"
LIB="lib"
if test `arch` = "x86_64"; then
        LIB="lib64"
        ZEND_ARCH="x86_64"
fi

[  -z $1 ] && DOWNLOAD_PHP_URL="https://raw.githubusercontent.com/viagram/docker/master/centos6-kangle" || DOWNLOAD_PHP_URL=$1

wget --no-check-certificate -c http://hk2.php.net/get/php-5.4.44.tar.bz2/from/this/mirror -O php-5.4.44.tar.bz2
tar xjf php-5.4.44.tar.bz2
cd php-5.4.44
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
        wget --no-check-certificate -c $DOWNLOAD_PHP_URL/php5444/config.xml -O $PREFIX/config.xml
fi
cd ..
wget --no-check-certificate -c $DOWNLOAD_PHP_URL/php5444/php-templete.ini -O $PREFIX/php-templete.ini
#install zend
wget --no-check-certificate -c http://iweb.dl.sourceforge.net/project/kanglewebserver/php/5.4/5443/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-$ZEND_ARCH.tar.gz
tar zxf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-$ZEND_ARCH.tar.gz
cd ZendGuardLoader-70429-PHP-5.4-linux-glibc23-$ZEND_ARCH
cd php-5.4.x
mkdir -p $PREFIX/zend
\mv ZendGuardLoader.so $PREFIX/zend/ZendGuardLoader.so
#install ioncube
wget --no-check-certificate -c http://iweb.dl.sourceforge.net/project/kanglewebserver/php/5.4/5443/ioncube-$ZEND_ARCH-5.4.zip
unzip ioncube-$ZEND_ARCH-5.4.zip
mkdir -p $PREFIX/ioncube
\mv ioncube_loader_lin_5.4.so $PREFIX/ioncube/ioncube_loader_lin_5.4.so
rm -rf /tmp/*
/vhs/kangle/bin/kangle -r
cd ..
cd ..
