FROM centos:centos7.4
MAINTAINER CentOS 7.4.1708 <viagram.yang@gmail.com>

LABEL name="CentOS Base Image" \
	    vendor="CentOS7" \
	    license="GPLv2" \
	    build-date="20170925"
		
EXPOSE 22

RUN yum -y update; yum -y install wget curl curl-devel zlib-devel build-essential openssl openssl-devel openssh-server openssh passwd; yum clean all

COPY ./docker-start.sh /docker-start.sh
RUN chmod 775 /docker-start.sh

ENTRYPOINT ["/docker-start.sh"]
CMD ["/usr/sbin/sshd", "-D"]
