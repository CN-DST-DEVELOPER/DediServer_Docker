# 独立服务器 docker 镜像快速部署

### 0.简介

本镜像用以快速部署独立服务器，上传存档文件即可启动服务器，无需考虑独立服务器手动安装 mod，加载存档时将自动从工坊下载存档所需的 mod

**注意：v0.2 版本与之前版本配置文件不兼容，需要修改`docker-compose.yml`**

### 1.安装 docker 和 docker-compose

### 2.下载 docker-compose.yml

`wget https://raw.githubusercontent.com/CN-DST-DEVELOPER/DediServer_Docker/main/docker-compose.yml`

### 3.根据你服务器的具体情况修改配置

```shell
$ vim docker-compose.yml
```

```yaml
version: "3"
services:
  DST_DediServer:
    container_name: dst_server
    image: ghcr.io/cn-dst-developer/dediserver_docker:latest
    ports:
      # [服务器防火墙暴露端口]:[server.ini中设置的server_port]
      - 10998:10998/udp
      - 10999:10999/udp
    volumes:
      # 左侧修改为你的存档目录，是Cluster_1等的上层路径
      - ~/dst/saves:/usr/steamapps/dst/saves
      # 左侧修改为主机上储存mod目录，用以重建容器时mod不需要重新下载，此行非必需可删除
      - ~/dst/mods:/usr/steamapps/dst/dedicated_server/mods
      # 左侧修改为主机上储存v2版本mod目录，用以重建容器或切换存档时v2版本mod不需要重新下载，此行非必需可删除
      - ~/dst/ugc_mods:/usr/steamapps/workshop/content/322330
    environment:
      # 修改为你的存档名，默认为MyDediServer，此行非必需可删除
      - CLUSTER_NAME=MyDediServer
    logging:
      options:
        max-size: 10m
        max-file: "3"
```

ports 子项冒号左侧的端口号需要在防火墙打开，例如打开 27017 端口

```shell
$ sudo firewall-cmd --zone=public --add-port=27017/udp --permanent
```

依次打开全部端口后，需要执行

```shell
$ sudo firewall-cmd  --reload
```

刷新防火墙规则

将你本地游戏里配置 mod 后新建好的存档复制到上例`~/dst/saves`目录下，并将上例`MyDediServer`修改为你的存档名。

### 4.启动

```shell
$ sudo docker-compose up -d
```

### 5.下载加速

某些地区连接 ghcr.io 的速度较慢，可以改用自动生成的 DockerHub 镜像，充分利用各大镜像站的加速效果.

修改 docker-compose.yml 第五行：

~image: ghcr.io/cn-dst-developer/dediserver_docker:latest~

image: suv001/cn-dst-developer.dediserver_docker

### 6.已知问题

- 本镜像设计为服务器启动中出现任何问题均会异常退出，可能会在登录 steamcmd 和下载独立服务器时由于网络异常崩溃退出，重启即可；
- 某些特定情况下一些 Mod 可能会出现加载失败问题，如若重启仍出现，需要手动上传对应 mod 到服务器 mod 目录，可能原因是因为下载 mod 时出现了网络波动
