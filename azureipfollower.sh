#!/bin/bash

echo $KEY | base64 -d > /app/cert.pem

if [ -z "$SLEEP_TIME" ]; then
    SLEEP_TIME=300
fi

while true; do
    az login --service-principal -u "$APP_ID" -p "/app/cert.pem" --tenant "$TENANT_ID"

    rule_name="AzureIPFollowerAllowRule"
    
    # Get the current IP address
    current_ip=$(curl -s https://api.ipify.org)

    for nsg_and_rg in $NSG_AND_RESOURCE; do
        NSG_NAME=$(echo $nsg_and_rg | awk -F: '{print $1}')
        RESOURCE_GROUP_NAME=$(echo $nsg_and_rg | awk -F: '{print $2}')

        # check if a rule named $rule_name exists. If it does, update the IP address. If it doesn't, create a new rule.
        rule=$(az network nsg rule show --name $rule_name --nsg-name $NSG_NAME --resource-group $RESOURCE_GROUP_NAME --query "sourceAddressPrefixes" -o tsv)

        if [ -z "$rule" ]; then
            az network nsg rule create --name $rule_name --nsg-name $NSG_NAME --resource-group $RESOURCE_GROUP_NAME --priority 100 --source-address-prefixes $current_ip --destination-address-prefixes '*' --destination-port-ranges '*' --access Allow --protocol '*' --description "Allow traffic from current IP address"
        else
            az network nsg rule update --name $rule_name --nsg-name $NSG_NAME --resource-group $RESOURCE_GROUP_NAME --source-address-prefixes $current_ip
        fi
    done

    sleep $SLEEP_TIME
done
