#!/bin/sh -eux

#docker pull "ghcr.io/rekgrpth/gpdb.docker:${INPUTS_BRANCH:-latest}"
docker network create --attachable --ipv6 --subnet 2001:db8::/112 --opt com.docker.network.bridge.name=docker docker || echo $?
docker volume create gpdb
docker stop gpdb5 || echo $?
docker rm gpdb5 || echo $?
docker run \
    --cap-add=SYS_PTRACE \
    --detach \
    --env GP_MAJOR=5 \
    --env GROUP_ID="$(id -g)" \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID="$(id -u)" \
    --hostname gpdb5 \
    --init \
    --memory=16g \
    --memory-swap=16g \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/sys,destination=/sys,readonly \
    --mount type=volume,source=gpdb,destination=/home \
    --mount type=bind,source="$(docker volume inspect --format "{{ .Mountpoint }}" gpdb)/.local/5",destination=/usr/local \
    --mount type=bind,source=/tmpfs/data/5,destination=/home/.data/5 \
    --name gpdb5 \
    --network name=docker,alias=gpdb5."$(hostname -d)" \
    --privileged \
    --restart always \
    "ghcr.io/rekgrpth/gpdb.docker:${INPUTS_BRANCH:-centos}" sudo /usr/sbin/sshd -De
