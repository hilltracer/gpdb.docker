#!/bin/sh -eux

docker build \
    --build-arg PG_MAJOR=94 \
    --file pg94.Dockerfile \
    --pull \
    --tag pg94 \
    . 2>&1 | tee buildpg94.log
