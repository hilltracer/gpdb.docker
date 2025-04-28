#!/bin/sh -eux

docker network create --attachable --ipv6 --subnet 2001:db8::/112 --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop gpdb8u || echo $?
docker rm gpdb8u || echo $?
mkdir -p /tmp/data/8u /tmp/data/8u.test
docker run \
    --detach \
    --env GOPATH=/usr/local/go \
    --env GP_MAJOR=8u \
    --env GROUP_ID="$(id -g)" \
    --env LANG=en_US.UTF-8 \
    --env PGPORT=8000 \
    --env PORT_BASE=8000 \
    --env TZ=Europe/Moscow \
    --env USER_ID="$(id -u)" \
    --hostname gpdb8u \
    --init \
    --memory=16g \
    --memory-swap=16g \
    --mount type=bind,source=$HOME/gpdb/.local/8u,destination=/usr/local \
    --mount type=bind,source=/tmp/data/8u,destination=/home/gpadmin/.data \
    --mount type=bind,source=/tmp/data/8u.test,destination=/home/gpadmin/gpdb_src/src/test \
    --mount type=bind,source=$HOME/gpdb,destination=/home/gpadmin \
    --mount type=bind,source=$HOME/tasks,destination=/home/gpadmin/src/tasks \
    --name gpdb8u \
    --network name=docker \
    --privileged \
    --restart always \
    --sysctl "kernel.sem=500 1024000 200 4096" \
    --sysctl "net.unix.max_dgram_qlen=4096" \
    gpdb8u sudo /usr/sbin/sshd -De
