FROM viagram/centos6:latest
MAINTAINER CentOS <viagram.yang@gmail.com>

EXPOSE 22
EXPOSE 80

RUN yum -y update; yum clean all
RUN yum -y install wget curl curl-devel zlib-devel build-essential openssl openssl-devel openssh-server openssh passwd; yum clean all

COPY .init.sh /.init.sh
COPY kangle_install /kangle_install

RUN sh /kangle_install/ep.sh

ENTRYPOINT ["/.init.sh"]
CMD ["/usr/sbin/sshd", "-D"]
