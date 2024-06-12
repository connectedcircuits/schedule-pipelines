
param par_storName string
param par_location string = resourceGroup().location


resource stor 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: par_storName
  location: par_location
  sku: {
    name:  'Standard_LRS'
  }
  kind:  'StorageV2'
}
