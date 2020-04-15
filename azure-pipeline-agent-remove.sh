#!/bin/sh

if [ -z "$1 ]
  then
    if [ -z "${AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN}"]
    then
      echo "Kindly provide Personal Access Token"
    else
      pat="${AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN}"
      echo $pat
    fi
  else
    pat=$1
fi

sudo ./svc.sh stop
echo "Service stopped"

sudo ./svc.sh uninstall
echo "Service uninstalled"

./config.sh remove --unattended --auth pat --token $pat
echo "Configuration removed"
