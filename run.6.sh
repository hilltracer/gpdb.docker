#!/bin/sh -eux

#docker pull "ghcr.io/rekgrpth/gpdb.docker:${INPUTS_BRANCH:-latest}"
docker network create --attachable --ipv6 --subnet 2001:db8::/112 --opt com.docker.network.bridge.name=docker docker || echo $?
docker volume create gpdb
docker stop gpdb6 || echo $?
docker rm gpdb6 || echo $?
docker run \
    --detach \
    --env GP_MAJOR=6 \
    --env GROUP_ID="$(id -g)" \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID="$(id -u)" \
    --hostname gpdb6 \
    --init \
    --memory=16g \
    --memory-swap=16g \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=volume,source=gpdb,destination=/home \
    --mount type=bind,source="$(docker volume inspect --format "{{ .Mountpoint }}" gpdb)/.local/6",destination=/usr/local \
    --mount type=bind,source=/tmpfs/data/6,destination=/home/.data/6 \
    --name gpdb6 \
    --network name=docker,alias=gpdb6."$(hostname -d)" \
    --privileged \
    --restart always \
    --sysctl 'kernel.sem=500 1024000 200 4096' \
    "ghcr.io/rekgrpth/gpdb.docker:${INPUTS_BRANCH:-centos}" sudo /usr/sbin/sshd -De
#    --cap-add=SYS_PTRACE \
#    --mount type=bind,source=/sys,destination=/sys \
