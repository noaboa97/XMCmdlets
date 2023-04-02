# Variables 
$clientid = ""
$clientsecret = ""
$server = "YourServer:Port"
$group = "YourGroupName" 

# Get API Token / Creates the session
Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server

# Get all end systems
$endSystems = Get-XMCEndSystemsOfGroup -Group $group -XMCFQDN $server -token $xmcsession

#Backup all addresses to CSV
$endSystems | Export-csv -path "C:\temp\xmcendsystem2.csv"

# Filter for all devices with no description
$noDesc = $endSystems | Where-Object {$_.description -eq ""}

# Remove macs with no description
foreach($endSystem in $noDesc){

    # Write-Host "Removing $($endSystem.mac) from $group"
    $resp = Update-XMCAccessControlGroups -MacAddress $endSystem.mac -OperationType Remove  -XMCFQDN $server -TargetGroup $group

}
