FROM steamcmd/steamcmd:latest
LABEL org.opencontainers.image.source https://github.com/cn-dst-developer/dediserver_docker
RUN apt-get update && apt-get install -y libstdc++6 libgcc1 libcurl4-gnutls-dev lib32gcc1 libcurl4-gnutls-dev:i386

ADD ./start.sh /usr/bin/start_dst_dedicated_server.sh
ENTRYPOINT [ "bash", "/usr/bin/start_dst_dedicated_server.sh" ]  