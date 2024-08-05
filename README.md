# Fabric-IaC-UKS
Create Fabric Capacity and Logic App in UK South

1. Create new external Azure subscription
2. Add all old workspaces to github repos
3. Create new Fabric capacity in new subscription

```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```


Some content sourced from:  
- https://github.com/murggu/fabric-iac
- https://insight-services-apac.github.io/2024/07/23/fabric-bicep


1. [Login to Azure CLI:]()

```
az login --tenant <your-tenant-id>
```

2. Set the subscription:

```
az account set --subscription <your-subscription-id>
```

3. Deploy the Bicep file:

```
az deployment sub create --location <location> --template-file bicep/main.bicep
```

Replace `<your-subscription-id>` with your actual subscription ID and <location> with the desired Azure region (e.g., uksouth).



### Convert an ARM template to bicep

1. Export the ARM template from the Azure portal
2. Run the following code to decompile it:

```
az bicep decompile --file main.json
```

See here for more info: https://stackoverflow.com/questions/69354469/is-there-a-way-to-generate-a-bicep-file-for-an-existing-azure-resource