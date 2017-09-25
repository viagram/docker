FROM centos:centos7.4.1708
MAINTAINER CentOS 7.4.1708 <viagram.yang@gmail.com>
		
EXPOSE 22

COPY ./docker-start.sh /docker-start.sh
RUN chmod +x /docker-start.sh; yum -y update; yum -y install wget curl curl-devel zlib-devel build-essential openssl openssl-devel openssh-server openssh passwd; yum clean all

ENTRYPOINT ["/docker-start.sh"]
CMD ["/usr/sbin/sshd", "-D"]
