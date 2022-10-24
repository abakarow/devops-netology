#!/bin/bash
#source ./env.sh # for export to current shell
export TF_VAR_YANDEX_TOKEN=$(yc iam create-token)
export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
