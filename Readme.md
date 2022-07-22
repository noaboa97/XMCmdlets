# XMCmdlets a PowerShell wrapper for ExtremeCloud IQ Site Engine GraphQL API

This PowerShell module contains functions that handle authentication, add and remove of Mac addresses  currently only for accesscontrol groups in XMC.
It's a wrapper for the graphql API of the ExtremeCloud IQ Site Engine former XMC.

## Functions 
Currently it only provides three functions:
| Function  | Description   | Type   |
| ------------- | ------------- |:------:|
| Get-XMCToken | Retrieves the XMC API token and creates a session to use | PowerShell function |
| Update-XMCAccessControlGroups | Add or remove mac addresse from an access control group | PowerShell function |
| Remove-XMCSession | Removes the global XMC session from the current PS session | PowerShell function | 

### Get-XMCToken 
Retrieves the XMC API token and creates a session to use. Session is saved in a global variable $XMCSession.
also returns the session and could be passed as parameter to the Update-XMCAccessControlGroups.

#### Syntax
```powershell
Get-XMCToken
   [[-ClientID] <string[]>]
   [[-ClientSecret]<string[]>]
   [[-XMCFQDN]<string[]>]
   [<CommonParameters>]
```
#### Example
```powershell
    $clientid = "YourClientID"
    $clientsecret = "YourClientSecret"
    $server = "Hostname:Port"

    Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server

    $token = Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server
```

### Update-XMCAccessControlGroups 
Add or remove mac addresse from an access control group
#### Syntax
```powershell
Update-XMCAccessControlGroups 
   [[-TargetGroup] <string[]>]
   [[-MacAddress]<string[]>]
   [[-OperationType]<string[]>]
   [[-Token]<XMCSession[]>
   [[-XMCFQDN]<string[]>]
   [<CommonParameters>]
```
#### Example
```powershell
    $server = "Hostname:Port"
    $mac = "00:00:00:00:00:00"
    $targgroup = "YourAccessControlGroup" #e.g. SwissTPH-StagingDevices

    $resp = Update-XMCAccessControlGroups -MacAddress $mac -Operation Add -XMCFQDN $server -TargetGroup $targgroup

    $resp = Update-XMCAccessControlGroups -MacAddress $mac -Operation Add -XMCFQDN $server -TargetGroup $targgroup -Token $token
```


### Remove-XMCSession
Remove / clear the XMC session variable
#### Syntax
```powershell
Remove-XMCSession
   [[-Variable] <string[]>]
```
#### Example
```powershell
    Remove-XMCSession

    Remove-XMCSession -Variable "Token"
```

