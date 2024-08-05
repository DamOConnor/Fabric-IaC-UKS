param baseName string
param location string

resource logicAppNew 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'logicApp${baseName}'
  location: location
  properties: {
    definition: {
        '$schema': 'https://schema.management.azure.com/schemas/2016-06-01/Microsoft.Logic.json'
        contentVersion: '1.0.0.0'
        parameters: {}
        triggers: {}
        actions: {}
        outputs: {}
    }
  }
}
