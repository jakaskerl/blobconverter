#!/bin/bash

cd /app/depthai-model-zoo
git reset --hard
git clean -dfx
git pull
python3 /app/download_blobs.py