# graph-mailbox-user-purpose
The repository contains the PowerShell script for reading the user purpose of the mailbox either for a specific user or for all users in the tenant.

## Prerequisities
- Register the app in Azure ADD with the following application permissions
  - MailboxSettings.Read
  - User.Read.All
- Create a new client secret
- Install the **Microsoft.Graph** PowerShell module

## Examples
### Read the user purpose of a specific user

```
Get-UserMailboxSettingUserPurpose `
    -ClientId "<client_id>" `
    -TenantId "<tenant_id>" `
    -Secret "<client_secret>" `
    -UserId "<user_id> or <service_principal_name>"
```

### Read the user purpose for all users in the tenant
```
Get-UsersMailboxSettingUserPurpose `
    -ClientId "<client_id>" `
    -TenantId "<tenant_id>" `
    -Secret "<client_secret>" `
```