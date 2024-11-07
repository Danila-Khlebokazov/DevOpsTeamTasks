#!/bin/bash

sudo docker stop minio1

# mc - minio client
mc alias set local https://minio.local minioadmin minioadmin
mc admin info local --insecure
mc ls local/testbucket --insecure