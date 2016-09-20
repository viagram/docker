FROM centos:centos6.8
MAINTAINER CentOS <viagram.yang@gmail.com>

EXPOSE 22

RUN yum -y update; yum clean all
RUN yum -y install wget curl curl-devel zlib-devel build-essential openssl openssl-devel openssh-server openssh passwd; yum clean all

COPY docker-start.sh /docker-start.sh

ENTRYPOINT ["/docker-start.sh"]
CMD ["/usr/sbin/sshd", "-D"]
