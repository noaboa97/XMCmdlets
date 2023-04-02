# Variables 
$clientid = ""
$clientsecret = ""
$server = "YourServer:Port"
$mac = "00:00:00:00:00:00"
$targgroup = "YourGroupName"

# Get API Token
Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server

# Adding a new mac to an access control group
$resp = Update-XMCAccessControlGroups -MacAddress $mac -Operation Add -XMCFQDN $server -TargetGroup $targgroup

# some error handling in the console
if ($resp.data.accessControl.addEntryToGroup.status -eq "SUCCESS"){

    write-host "Mac $mac added to $targgroup"

}else{

    write-host "Error adding Mac $mac to $targgroup"

}

#Multi Edit
$macadresses = @("00:00:00:00:00:00";"00:00:00:00:00:00";"00:00:00:00:00:00";"00:00:00:00:00:00")
foreach($mac in $macadresses){
    Update-XMCAccessControlGroups -MacAddress $mac -Operation Add -XMCFQDN $server -TargetGroup $targgroup
}

# Remove mac from an access control group
$resp = Update-XMCAccessControlGroups -MacAddress "00:00:00:00:00:00" -OperationType Remove  -XMCFQDN $server -TargetGroup "YourGroupName"

Get-XMCEndSystemsOfGroup -Group "YourGroupName" -XMCFQDN $server 