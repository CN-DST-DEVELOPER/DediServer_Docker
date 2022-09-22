FROM steamcmd/steamcmd:latest
LABEL org.opencontainers.image.source https://github.com/cn-dst-developer/dediserver_docker
RUN apt-get update && apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386

ADD ./start.sh /root/start.sh
ENTRYPOINT [ "bash", "/root/start.sh" ]  