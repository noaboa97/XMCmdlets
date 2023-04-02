
$uri = "https://YourServer:Port/nbi/graphql"
$clientid = ""
$clientsecret = ""

$server = "YourServer:Port"

$rawtoken = Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server

$token = $rawtoken.access_token

$headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
        "Cache-Control" = "no-cache"

    }

#$myQuery = "query{accessControl{allEndSystemMacs}}"

$myQuery = '{"query":"query{accessControl{allEndSystemMacs}}"}'


$targetGroup = "YourGroupName"
$macAddress = "00:00:00:00:00:00"

# Add Mac Address
$xmcAddDeviceToCollectionQuery = "mutation { accessControl {addEntryToGroup (input:{group:""$targetGroup"",value:""$macAddress"",reauthenticate:false}) { clientSessionId errorCode message name operationId status }} }"

# Remove Mac Address
$xmcAddDeviceToCollectionQuery = "mutation { accessControl {removeMACFromEndSystemGroup (input:{group:""$targetGroup"",value:""$macAddress""}) { clientSessionId errorCode message name operationId status }} }"

$xmcAddDeviceToCollectionBody = @{
	query = $xmcAddDeviceToCollectionQuery
}

$xmcAddDeviceToCollectionBodyAsJson = $xmcAddDeviceToCollectionBody | ConvertTo-Json

$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -body $xmcAddDeviceToCollectionBodyAsJson

#Invoke-GraphQLQuery -uri $uri -Query $myQuery -Headers $headers 
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -body $myQuery  #-ContentType "application/json"
#Invoke-WebRequest -Uri $uri -headers $headers -Body $myquery #-ContentType "application/json" 



