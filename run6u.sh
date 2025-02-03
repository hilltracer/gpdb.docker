#!/bin/sh -eux

docker network create --attachable --ipv6 --subnet 2001:db8::/112 --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop gpdb6u || echo $?
docker rm gpdb6u || echo $?
mkdir -p /tmp/data/6u /tmp/data/6u.test
docker run \
    --detach \
    --env GOPATH=/usr/local/go \
    --env GP_MAJOR=6u \
    --env GROUP_ID="$(id -g)" \
    --env LANG=en_US.UTF-8 \
    --env PGPORT=6000 \
    --env PORT_BASE=6000 \
    --env TZ=Europe/Moscow \
    --env USER_ID="$(id -u)" \
    --hostname gpdb6u \
    --init \
    --memory=16g \
    --memory-swap=16g \
    --mount type=bind,source=$HOME/gpdb/.local/6u,destination=/usr/local \
    --mount type=bind,source=/tmp/data/6u,destination=/home/gpadmin/.data \
    --mount type=bind,source=/tmp/data/6u.test,destination=/home/gpadmin/gpdb_src/src/test \
    --mount type=bind,source=$HOME/gpdb,destination=/home/gpadmin \
    --mount type=bind,source=$HOME/tasks,destination=/home/gpadmin/src/tasks \
    --name gpdb6u \
    --network name=docker \
    --privileged \
    --restart always \
    --sysctl "kernel.sem=500 1024000 200 4096" \
    --sysctl "net.unix.max_dgram_qlen=4096" \
    gpdb6u sudo /usr/sbin/sshd -De
