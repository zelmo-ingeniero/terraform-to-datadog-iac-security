
# Exploring the Azure provider

## Authentication

The best way is that Terraform uses an already existing Service Pincipal (one pair of username and password, are like "service accounts" or "application accounts"). If not exists previously, once loged in to the Azure CLI create the Service Principal

```bash
az ad sp create-for-rbac --name <service-principal-terraform> --role Contributor --scopes /subscriptions/<subscription-id>
```

(This appears in Entra ID > Enterprise applications)

The AppId and the password are secrets, then export in the device the next environment variables (maybe can be in files and add to Terraform the `client_secret_file_path` argument)

```bash
export ARM_CLIENT_ID="<APPID_VALUE>"
export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
export ARM_TENANT_ID="<TENANT_VALUE>"
```

By this method, is possible to keep the Azure CLI in the device with your account but Terraform only will have access to the subscription specified at the Service Principal. Keep in mind that you can be a Service Principal in the Azure CLI

```bash
az login --service-principal -u <appId> -p <password> --tenant <tenant>
```

I noticed that the Azure CLI let you only manage 1 subscription at time

## Azure issues

Resource providers (Azure services) that are enabled by default:

Microsoft.SerialConsole
Microsoft.Commerce
Microsoft.Marketplace
Microsoft.MarketplaceOrdering
Microsoft.Support
Microsoft.ADHybridHealthService
Microsoft.Autorization
Microsoft.Billing
Microsoft.ClassicSubscription
Microsoft.Comsumption
Microsoft.CostManagement
Microsoft.Features
Microsoft.Portal
Microsoft.ResourceGraph
Microsoft.Resources

I noticed that Entra (new name of Active Directory) is a different Microsoft service with their own web console, then your Azure user account is really an Microsoft Entra account

https://entra.microsoft.com/#home 


## HCL Providers or Terraform providers to azure

There are three providers created by HashiCorp and other three directly by Azure
 
 - 'azurerm' by HashiCorp: This is the primary provider for managing Azure resources
 - 'azuread' by HashiCorp: This one is specialized for managing Azure Active Directory resources
 - 'azurestack' by HashiCorp: This is used to manage resources in Azure Stack via the Azure Resource Manager API's
 - 'alz' by Microsoft: Use the Azure Landing Zones provider to generate data. The provider does deploy some resources directly in order to avoid limitations 
 - 'azapi' by Microsoft: Currently in preview, allows you to leverage the Azure RM REST API directly. This has extra resources that the azurerm doesn't support
 - 'motd' by Microsoft: This will not be used 

## The Terraform remote state

It seems like Azure Blob is the best option to store the terraform state because Azure has compatibility with Terraform according to them

> test
mongodb+srv://sergiovalencia:0byrkqTq5LgKyk9W@cluster0.x0ny0nr.mongodb.net/?retryWrites=true&w=majority
