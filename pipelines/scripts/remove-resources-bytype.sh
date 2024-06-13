#!/bin/bash

# Get the parameters
resourceGroupName=$1
resourceTypes=$2


# Split the newline-separated string into an array
readarray -t resourceTypesArray < <(printf '%s\n' "$resourceTypes" | tr ' ' '\n')

# Loop through each resource type in the array and delete all resources of that type
for resourceType in "${resourceTypesArray[@]}"
do
    echo "------------------------------------------------------------------"
    echo "Fetching resources of type: $resourceType in RG $resourceGroupName"
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

