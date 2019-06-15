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
cd /opt
mkdir agent
cd agent

# Get Agent Version and Agent URL to download.
AGENTRELEASE="$(curl -s https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases/latest | grep -oP '"tag_name": "v\K(.*)(?=")')"
AGENTURL="https://vstsagentpackage.azureedge.net/agent/${AGENTRELEASE}/vsts-agent-linux-x64-${AGENTRELEASE}.tar.gz"
echo "Release "${AGENTRELEASE}" is latest"

echo "Downloading..."
wget -O agent.tar.gz ${AGENTURL} 
tar zxvf agent.tar.gz
chmod -R 777 .
echo "extracted"

sudo ./bin/installdependencies.sh
echo "dependencies installed"

sudo -u azuredevopsuser ./config.sh --unattended --url $azureDevOpsServerUrl --auth pat --token $pat --pool $agentPool --agent $agentName --acceptTeeEula --work ./_work --runAsService
echo "configuration done"

sudo ./svc.sh install
echo "service installed"

sudo ./svc.sh start
echo "service started"

exit 0