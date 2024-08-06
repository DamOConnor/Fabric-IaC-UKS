// Setup

targetScope = 'subscription'

@description('The location for all resources deployed in this template')
param location string = 'uksouth'

@description('The core name that will be used for resources')
param prefix string = 'general'

@description('The text that will be suffixed to the end of resource names')
param postfix string = 'uks'

@description('The Fabric F-SKU size, eg F2, F64 etc')
param sku string = 'F2'

@description('The admin email - used in the authorisation for the Logic App')
param adminEmail string

var baseName  = '${prefix}-${postfix}'
var resourceGroupName = 'rg-${baseName}'
var safeBaseName = '${prefix}${postfix}'

var fabricCapacityName = 'fab${safeBaseName}'
var logicAppName = 'la-pause-fab${safeBaseName}'

// Resource group

resource rg_res 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

// Fabric capacity

module fab_mod './fabric_capacity.bicep' = {
  name: 'fab'
  scope: resourceGroup(rg_res.name)
  params: {
    adminEmail: adminEmail
    fabricCapacityName: fabricCapacityName
    location: location
    sku: sku
  }
}


// ARM API Connection

module arm_mod './arm.bicep' = {
  name: 'arm'
  scope: resourceGroup(rg_res.name)
  params: {
    tenantId: subscription().tenantId   
    adminEmail: adminEmail
  }
}


// Logic App

module logicApp_mod './logic_app.bicep' = {
  name: 'logicApp'
  scope: resourceGroup(rg_res.name)
  params: {
    fabricCapacityName: fabricCapacityName
    location: location
    logicAppName: logicAppName
    resourceGroupName: resourceGroupName
    subscriptionId: subscription().subscriptionId
  }
  dependsOn: [
    fab_mod
    arm_mod
  ]
}
