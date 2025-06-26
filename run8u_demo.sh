#!/bin/sh -eux

docker pull hub.adsw.io/library/gpdb8_u22:adb-8.x || echo $?
docker stop gpdb8u_demo || echo $?
docker rm gpdb8u_demo || echo $?

docker run \
    --detach \
    --hostname gpdb8u_demo \
    --init \
    --memory=16g \
    --memory-swap=16g \
    --mount type=bind,source=$HOME/gpdb,destination=/home/gpadmin/gpdb2 \
    --mount type=bind,source=$HOME/tasks,destination=/home/gpadmin/gpdb2/src/tasks \
    --name gpdb8u_demo \
    --privileged \
    --restart always \
    --sysctl "kernel.sem=500 1024000 200 4096" \
    hub.adsw.io/library/gpdb8_u22:adb-8.x sudo /usr/sbin/sshd -De


#   echo 'source /usr/local/greenplum-db-devel/greenplum_path.sh' >> ~gpadmin/.bashrc &&
  # echo 'source /home/gpadmin/gpdb_src/gpAux/gpdemo/gpdemo-env.sh' >> ~gpadmin/.bashrc &&
  # su - gpadmin &&
  # source ~gpadmin/.bashrc &&
  # createdb --owner=\\\$USER \\\$USER


# docker run --name gpdb8_demo -it \
# --sysctl 'kernel.sem=500 1024000 200 4096' \
# hub.adsw.io/library/gpdb8_u22:adb-8.x \




# --hostname gpdb8u_demo \

  # echo 'source /usr/local/greenplum-db-devel/greenplum_path.sh' >> ~gpadmin/.bashrc &&
  # echo 'source ~/gpdb_src/gpAux/gpdemo/gpdemo-env.sh' >> ~gpadmin/.bashrc &&
  # su - gpadmin &&
  # createdb --owner=\\\$USER \\\$USER

  # su - gpadmin -c '
  #   bash --login -c \"
  #     source /usr/local/greenplum-db-devel/greenplum_path.sh &&
  #     source ~/gpdb_src/gpAux/gpdemo/gpdemo-env.sh &&
  #     createdb --owner=\\\$USER \\\$USER &&
  #     exec bash
  #   \"
  # '

