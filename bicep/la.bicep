@description('Base name for resources')
param baseName string

@description('The location for the Logic App')
param location string

@description('ARM connection external ID')
param connections_arm_externalid string

@description('Subscription ID for the target resources')
param subscriptionId string

resource logicApp 'Microsoft.Logic/workflows@2021-06-01' = {
  name: 'lapausefabric'
  location: location
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        Recurrence: {
          recurrence: {
            interval: 1
            frequency: 'Day'
            timeZone: 'GMT Standard Time'
            schedule: {
              hours: [
                '21'
              ]
            }
          }
          evaluatedRecurrence: {
            interval: 1
            frequency: 'Day'
            timeZone: 'GMT Standard Time'
            schedule: {
              hours: [
                '21'
              ]
            }
          }
          type: 'Recurrence'
        }
      }
      actions: {
        Invoke_resource_operation: {
          runAfter: {}
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'arm\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/subscriptions/@{encodeURIComponent(subscriptionId)}/resourcegroups/@{encodeURIComponent(\'rg-${baseName}\')}/providers/@{encodeURIComponent(\'Microsoft.Fabric\')}/@{encodeURIComponent(\'capacities/fab${baseName}\')}/@{encodeURIComponent(\'suspend\')}'
            queries: {
              'x-ms-api-version': '2023-11-01'
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          arm: {
            id: '/subscriptions/${subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/arm'
            connectionId: connections_arm_externalid
            connectionName: 'arm'
          }
        }
      }
    }
  }
}
