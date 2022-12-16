# XMCmdlets a PowerShell wrapper for ExtremeCloud IQ Site Engine GraphQL API
 
 This PowerShell module contains functions that handle authentication, add and remove for currently only accesscontrol groups in XMC.
It is a wrapper for the graphql API of the ExtremeCloud IQ Site Engine former XMC.
 
 ## Functions
Currently it provides the following functions
| Function  | Description   | Type   |
| ------------- | ------------- |:------:|
| Get-XMCEndSystemsOfGroup | Retrieves all end systems of a group | PowerShell Function |
| Get-XMCToken | Retrieves the XMC API token | PowerShell Function |
| Remove-XMCSession | Remove / clear the XMC session variable | PowerShell Function |
| Update-XMCAccessControlGroups | Add or remove mac addresse from an access control group | PowerShell Function | 
 
### Get-XMCEndSystemsOfGroup
#### SYNTAX
``` powershell
Get-XMCEndSystemsOfGroup
   [-Group] <String>
   [[-Token] <XMCSession>]
   [-XMCFQDN] <String>
```

#### Examples

``` powershell
$server = "Hostname:Port"
$group = "YourAccessControlGroup" #e.g. SwissTPH-StagingDevices

$resp = Get-XMCEndSystemsOfGroup -Group $group -XMCFQDN $server -token $xmcsession    
$resp = Get-XMCEndSystemsOfGroup -Group "YourAccessControlGroup" -XMCFQDN $server -token $xmcsession
```

### Get-XMCToken
#### SYNTAX
``` powershell
Get-XMCToken
   [-ClientID] <String>
   [-ClientSecret] <String>
   [-XMCFQDN] <String>
```

#### Examples

``` powershell
$clientid = "YourClientID"
$clientsecret = "YourClientSecret"
$server = "Hostname:Port"

Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server    
$token = Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server
```

### Remove-XMCSession
#### SYNTAX
``` powershell
Remove-XMCSession
   [[-Variable] <String>]
```

#### Examples

``` powershell
Remove-XMCSession
    
Remove-XMCSession -Variable "Token"
```

### Update-XMCAccessControlGroups
#### SYNTAX
``` powershell
Update-XMCAccessControlGroups
   [-TargetGroup] <String>
   [-MacAddress] <String>
   [-OperationType] <Object>
   [[-Token] <XMCSession>]
   [-XMCFQDN] <String>
```

#### Examples

``` powershell
$server = "Hostname:Port"
$mac = "00:00:00:00:00:00"
$targgroup = "YourAccessControlGroup" #e.g. SwissTPH-StagingDevices

$resp = Update-XMCAccessControlGroups -MacAddress $mac -Operation Add -XMCFQDN $server -TargetGroup $targgroup    
$resp = Update-XMCAccessControlGroups -MacAddress $mac -Operation Add -XMCFQDN $server -TargetGroup $targgroup -Token $token
```

