FROM centos:centos7.9.2009
LABEL org.opencontainers.image.source https://github.com/cn-dst-developer/dedicated_server_docker
RUN yum install -y wget glibc.i686 glibc.x86_64 libstdc++.x86_64 libcurl.x86_64 &&\
    ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4

RUN mkdir -p ~/steamcmd/ &&\
    cd ~/steamcmd/ &&\
    wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" &&\
    tar -xvzf steamcmd_linux.tar.gz &&\
    rm -f steamcmd_linux.tar.gz

ADD ./start.sh /root/start.sh
ENTRYPOINT [ "bash", "/root/start.sh" ]  