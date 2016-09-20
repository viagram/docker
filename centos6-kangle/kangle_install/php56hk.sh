#!/bin/sh

yum -y install bzip2-devel libxml2-devel curl-devel db4-devel libjpeg-devel libpng-devel freetype-devel pcre-devel zlib-devel sqlite-devel libmcrypt-devel 
yum -y install mhash-devel openssl-devel unzip
yum -y install libtool-ltdl libtool-ltdl-devel
PREFIX="/vhs/kangle/ext/php56"
ZEND_ARCH="i386"
LIB="lib"
if test `arch` = "x86_64"; then
        LIB="lib64"
        ZEND_ARCH="x86_64"
fi

wget -c http://hk2.php.net/get/php-5.6.12.tar.bz2/from/this/mirror  -O php-5.6.12.tar.bz2
tar xjf php-5.6.12.tar.bz2
cd php-5.6.12
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
cd ..
\mv /kangle_install/php56/config.xml $PREFIX/config.xml
\mv /kangle_install/php56/php-templete.ini $PREFIX/php-templete.ini
#install ioncube
wget -c https://raw.githubusercontent.com/1265578519/kangle/master/php/5.6/5611/ioncube-$ZEND_ARCH-5.6.zip
unzip ioncube-$ZEND_ARCH-5.6.zip
mkdir -p $PREFIX/ioncube
\mv ioncube_loader_lin_5.6.so $PREFIX/ioncube/ioncube_loader_lin_5.6.so
wget http://pecl.php.net/get/memcache-3.0.8.tgz
tar zxf memcache-3.0.8.tgz
cd memcache-3.0.8
$PREFIX/bin/phpize
./configure --with-php-config=$PREFIX/bin/php-config
make
make install
cd ..
wget http://pecl.php.net/get/apcu-4.0.7.tgz
tar zxf apcu-4.0.7.tgz
cd apcu-4.0.7
$PREFIX/bin/phpize
./configure --with-php-config=$PREFIX/bin/php-config
make
make install
/vhs/kangle/bin/kangle -r
cd ..
