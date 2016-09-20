FROM viagram/centos6-ssh:latest
MAINTAINER CentOS <viagram.yang@gmail.com>

EXPOSE 22
EXPOSE 81
EXPOSE 82

RUN yum -y update; yum clean all
RUN yum -y install wget curl curl-devel zlib-devel build-essential openssl openssl-devel openssh-server openssh passwd; yum clean all

COPY ./docker-start.sh /docker-start.sh
COPY ./kangle_install /kangle_install

RUN chmod 775 /docker-start.sh
RUN chmod 775 /kangle_install/ep.sh
RUN sh /kangle_install/ep.sh

ENTRYPOINT ["/docker-start.sh"]
CMD ["/usr/sbin/sshd", "-D"]
