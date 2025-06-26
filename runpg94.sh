#!/bin/sh -eux

docker network create --attachable --ipv6 --subnet 2001:db8::/112 --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop pg94 || echo $?
docker rm pg94 || echo $?
mkdir -p /tmp/data/pg94 /tmp/data/pg94.test
docker run \
    --detach \
    --env GOPATH=/usr/local/go \
    --env PG_MAJOR=94 \
    --env GROUP_ID="$(id -g)" \
    --env LANG=en_US.UTF-8 \
    --env PGPORT=5432 \
    --env PORT_BASE=5432 \
    --env TZ=Europe/Moscow \
    --env USER_ID="$(id -u)" \
    --hostname pg94 \
    --init \
    --memory=16g \
    --memory-swap=16g \
    --mount type=bind,source=$HOME/gpdb/.local/pg94,destination=/usr/local \
    --mount type=bind,source=/tmp/data/pg94,destination=/home/gpadmin/.data \
    --mount type=bind,source=/tmp/data/pg94.test,destination=/home/gpadmin/gpdb_src/src/test \
    --mount type=bind,source=$HOME/gpdb,destination=/home/gpadmin \
    --mount type=bind,source=$HOME/tasks,destination=/home/gpadmin/src/tasks \
    --name pg94 \
    --network name=docker \
    --privileged \
    --restart always \
    --sysctl "kernel.sem=500 1024000 200 4096" \
    --sysctl "net.unix.max_dgram_qlen=4096" \
    pg94 sudo /usr/sbin/sshd -De
