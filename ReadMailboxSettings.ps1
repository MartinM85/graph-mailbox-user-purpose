# Get the user purpose of the mailbox for a specific user
# Requires MailboxSettings.Read permission
function Get-UserMailboxSettingUserPurpose {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [string] $ClientId,
        [parameter(Mandatory)]
        [string] $TenantId,
        [parameter(Mandatory)]
        [string] $Secret,
        [parameter(Mandatory)]
        [string] $UserId
    )

    $securedPasswordPassword = ConvertTo-SecureString `
    -String $Secret -AsPlainText -Force

    $clientSecretCredential = New-Object `
    -TypeName System.Management.Automation.PSCredential `
    -ArgumentList $ClientId, $securedPasswordPassword

    Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $clientSecretCredential

    Import-Module Microsoft.Graph.Users

    $settings = Get-MgUserMailboxSetting -UserId $UserId -Property "userPurpose"
    return $settings.UserPurpose
}

# Get the user purpose of the mailbox for all users in the tenant. Guest users are excluded
# Requires User.Read.All MailboxSettings.Read permissions
function Get-UsersMailboxSettingUserPurpose {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [string] $ClientId,
        [parameter(Mandatory)]
        [string] $TenantId,
        [parameter(Mandatory)]
        [string] $Secret
    )

    $securedPasswordPassword = ConvertTo-SecureString `
    -String $Secret -AsPlainText -Force

    $clientSecretCredential = New-Object `
    -TypeName System.Management.Automation.PSCredential `
    -ArgumentList $ClientId, $securedPasswordPassword

    Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $clientSecretCredential

    Import-Module Microsoft.Graph.Users

    $usersPurpose = @{}
    $users = Get-MgUser `
                -Property "id,displayName,userPrincipalName" `
                -Filter "UserType ne 'Guest'" `
                -ConsistencyLevel eventual `
                -CountVariable CountVar `
                | ForEach-Object {
                    $settings = Get-MgUserMailboxSetting -UserId $_.Id -Property "userPurpose"
                    $usersPurpose[$_.Id]=$settings.UserPurpose
                }
    return $usersPurpose
} 

Get-UserMailboxSettingUserPurpose `
    -ClientId "..." `
    -TenantId "..." `
    -Secret "..." `
    -UserId "..."

Get-UsersMailboxSettingUserPurpose `
    -ClientId "..." `
    -TenantId "..." `
    -Secret "..."