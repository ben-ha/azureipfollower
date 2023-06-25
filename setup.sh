#!/bin/bash

az login --use-device-code

SERVICE_PRINCIPAL_NAME="AzureIPFollower"

# Create a new service principal
output=$(az ad sp create-for-rbac --name "$SERVICE_PRINCIPAL_NAME" --create-cert -o tsv)
appid=$(echo $output | awk '{print $1}')
cert_location=$(echo $output | awk '{print $3}')
base64_cert=$(base64 -i $cert_location)
rm $cert_location

# Allow service principal to change NSG rules
az role assignment create --assignee "$appid" --role "Network Contributor"

# get tenant id
tenant_id=$(az account show --query tenantId -o tsv)

echo "TENANT_ID=$tenant_id" > .env
echo "APP_ID=$appid" >> .env
echo "KEY=$base64_cert" >> .env

echo "Successfully created service principal. Parameters for the follower container are stored in .env file."