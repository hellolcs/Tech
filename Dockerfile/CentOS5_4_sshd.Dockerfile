FROM gpmidi/centos-5.4
MAINTAINER Lim <hellolcs@castis.com>

RUN sed -i -e 's/#baseurl=http:\/\/mirror.centos.org\/centos\/\$releasever/baseurl=http:\/\/vault.centos.org\/5.4/g' \
           -e 's/mirrorlist/#mirrorlist/g' \
           /etc/yum.repos.d/*

RUN yum install -y epel-release && yum -y clean all
# useful package 
RUN yum install -y vim-enhanced && yum -y clean all
# install library for castis
RUN rpm --rebuilddb && yum install -y boost \
       boost-devel \
       tbb \
       tar \
       zip \
       unzip \
       bzip2 \
    && yum -y clean all

# for ssh connection
RUN yum -y install openssh-clients openssh-server && yum -y clean all && \
    echo "root:castis" | chpasswd && \
    /usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    /usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    sed -i 's/^#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
