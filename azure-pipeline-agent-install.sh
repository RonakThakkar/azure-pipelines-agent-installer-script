#!/bin/sh

# Read input parameters
if [ -z "$1" ]
  then
    if [ -z "${AZURE_DEVOPS_SERVER_URL}" ]
    then
        echo "Kindly provide Azure DevOps Server URL."
        exit 2
    else
        azureDevOpsServerUrl=${AZURE_DEVOPS_SERVER_URL}
        echo $azureDevOpsServerUrl
    fi
  else
    azureDevOpsServerUrl=$1
fi

if [ -z "$2" ]
  then
    if [ -z "${AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN}" ]
    then
        echo "Kindly provide Personal Access Token."
        exit 2
    else
        pat=${AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN}
        echo $pat
    fi
  else
    pat=$2
fi

if [ -z "$3" ]
  then
    agentPool=Default
  else
    agentPool=$3
fi

if [ -z "$4" ]
  then
    agentName=$(hostname)
  else
    agentName=$4
fi

echo "start"
cd /home/azuredevopsuser
mkdir agent
cd agent

sudo -u azuredevopsuser ./config.sh --unattended --url $azureDevOpsServerUrl --auth pat --token $pat --pool $agentPool --agent $agentName --acceptTeeEula --work ./_work --runAsService
echo "configuration done"

sudo ./svc.sh install
echo "service installed"

sudo ./svc.sh start
echo "service started"

exit 0