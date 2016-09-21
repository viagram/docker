FROM centos:centos6.8
MAINTAINER CentOS <viagram.yang@gmail.com>

EXPOSE 22

RUN yum -y update; yum clean all
RUN yum -y install wget curl curl-devel zlib-devel build-essential openssl openssl-devel openssh-server openssh passwd; yum clean all
RUN rm -f /.ssh_key_set;rm -f /.user_pw_set;rm -rf /home/user;userdel user

COPY ./docker-start.sh /docker-start.sh
RUN chmod 775 /docker-start.sh

ENTRYPOINT ["/docker-start.sh"]
CMD ["/usr/sbin/sshd", "-D"]
