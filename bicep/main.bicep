// Setup

targetScope = 'subscription'

param location string = 'uksouth'
param prefix string = 'generalii'
param postfix string = 'uks'
param sku string = 'F2'
param adminEmail string

var baseName  = '${prefix}-${postfix}'
var resourceGroupName = 'rg-${baseName}'
var safeBaseName = '${prefix}${postfix}'

var fabricCapacityName = 'fab${safeBaseName}'
var logicAppName = 'la-pause-fab${safeBaseName}'

// Resource group

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

// Fabric capacity

module fab './fabric_capacity.bicep' = {
  name: 'fab'
  scope: resourceGroup(rg.name)
  params: {
    adminEmail: adminEmail
    fabricCapacityName: fabricCapacityName
    location: location
    sku: sku
  }
}


// ARM API Connection

module arm './arm.bicep' = {
  name: 'arm'
  scope: resourceGroup(rg.name)
  params: {
    tenantId: subscription().tenantId   
    adminEmail: adminEmail
  }
}


// Logic App

module logicApp './logic_app.bicep' = {
  name: 'logicApp'
  scope: resourceGroup(rg.name)
  params: {
    fabricCapacityName: fabricCapacityName
    location: location
    logicAppName: logicAppName
    resourceGroupName: resourceGroupName
    subscriptionId: subscription().subscriptionId
  }
  dependsOn: [
    fab
    arm
  ]
}



// Logic App
//module logicApp './logic_app.bicep' = {
//  name: 'logicApp'
//  scope: resourceGroup(rg.name)
//  params: {
//    baseName: safeBaseName
//    location: location
//    connections_arm_externalid: connections_arm_externalid
//    subscriptionId: subscriptionId
//    tenantId: tenantId
//  }
//}
