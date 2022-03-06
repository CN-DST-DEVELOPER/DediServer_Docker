# 独立服务器docker镜像快速部署

### 0.简介

本镜像用以快速部署独立服务器，上传存档文件，无需考虑独立服务器手动安装mod，加载存档时将自动从工坊下载存档所需的mod

### 1.安装docker和docker-compose

### 2.下载docker-compose.yml

`wget https://raw.githubusercontent.com/CN-DST-DEVELOPER/DediServer_Docker/main/docker-compose.yml`

### 3.根据你服务器的具体情况修改配置

```shell
$ vim docker-compose.yml
```

```yaml
version: '3'
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
      - ~/dst/saves:/root/.klei/DoNotStarveTogether
      # 左侧修改为主机上储存mod目录，用以重建容器时mod不需要重新下载，此行非必需可删除
      - ~/dst/mods:/root/Steam/steamapps/common/Don't Starve Together Dedicated Server/mods
      # 左侧修改为主机上储存v2版本mod目录，用以重建容器或切换存档时v2版本mod不需要重新下载，此行非必需可删除
      - ~/dst/ugc_mods:/root/Steam/steamapps/workshop/content/322330
    environment:
      # 修改为你的存档名，默认为MyDediServer，此行非必需可删除
      - CLUSTER_NAME=MyDediServer
```

ports子项冒号左侧的端口号需要在防火墙打开，例如打开27017端口

```shell
$ sudo firewall-cmd --zone=public --add-port=27017/udp --permanent
```

依次打开全部端口后，需要执行

```shell
$ sudo firewall-cmd  --reload
```

刷新防火墙规则



将你本地游戏里配置mod后新建好的存档复制到上例`~/dst/saves`目录下，并将上例`MyDediServer`修改为你的存档名。

### 4.启动

```shell
$ sudo docker-compose up -d
```

### 5.已知问题

本镜像设计为服务器启动中出现任何问题均会异常退出，可能会在登录steamcmd和下载独立服务器时由于网络异常崩溃退出，重启即可。