#!/bin/sh -eux

docker pull hub.adsw.io/library/gpdb6_u22:adb-6.x-dev || echo $?
docker stop gpdb6u_demo || echo $?
docker rm gpdb6u_demo || echo $?

docker run \
    --detach \
    --hostname gpdb6u_demo \
    --init \
    --memory=16g \
    --memory-swap=16g \
    --mount type=bind,source=$HOME/gpdb,destination=/home/gpadmin/gpdb2 \
    --mount type=bind,source=$HOME/tasks,destination=/home/gpadmin/gpdb2/src/tasks \
    --name gpdb6u_demo \
    --privileged \
    --restart always \
    --sysctl "kernel.sem=500 1024000 200 4096" \
    hub.adsw.io/library/gpdb6_u22:adb-6.x-dev sudo /usr/sbin/sshd -De