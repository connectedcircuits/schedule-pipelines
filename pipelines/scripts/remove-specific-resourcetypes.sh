#!/bin/bash

# Define variables
resourceGroupName="daily-development"

# Define the array variable with elements on separate lines for each resource type you want to delete
IFS=$'\n' read -d '' -r -a resourceTypes <<EOF
Microsoft.Compute/virtualMachines
Microsoft.Network/networkInterfaces
Microsoft.Storage/storageAccounts
EOF


# Loop through each resource type in the array and delete all resources of that type
for resourceType in "${resourceTypes[@]}"
do
    echo "Fetching resources of type: $resourceType in $resourceGroupName"
    resourceIds=$(az resource list --resource-group $resourceGroupName --resource-type $resourceType --query "[].id" --output tsv)
    
    # Loop through each resource ID and delete the resource
    for resourceId in $resourceIds
    do
        # Extract the resource name from the resource ID
        resourceName=$(echo $resourceId | awk -F'/' '{print $NF}')
        echo "Deleting resource: $resourceName"
        az resource delete --ids $resourceId
    done
done

echo "All resources inside $resourceGroupName of types ${resourceTypes[*]} have been deleted."
