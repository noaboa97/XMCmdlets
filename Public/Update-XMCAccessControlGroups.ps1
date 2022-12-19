function Update-XMCAccessControlGroups {
    <#
    .SYNOPSIS
    Add or remove mac addresse from an access control group
    .DESCRIPTION
    Add or remove mac addresse from an access control group

    .PARAMETER TargetGroup
    Group to which the mac address should be added or removed

    .PARAMETER MacAddress
    Mac Address of the client which should be added or removed

    .PARAMETER OperationType
    Type of operation add or remove

    .PARAMETER Token
    Session token which is retrieved with Get-XMCToken - Optional
    If no token is passed the global session variable will be used.

    .PARAMETER XMCFQDN
    Extreme Cloud IQ Site Engine URL with Port

    .OUTPUTS
    Status of the operation

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  11.07.2022
    Purpose/Change: Initial function development
  
    .EXAMPLE
    $server = "Hostname:Port"
    $mac = "00:00:00:00:00:00"
    $targgroup = "YourAccessControlGroup" #e.g. SwissTPH-StagingDevices

    $resp = Update-XMCAccessControlGroups -MacAddress $mac -Operation Add -XMCFQDN $server -TargetGroup $targgroup


    .EXAMPLE
    $resp = Update-XMCAccessControlGroups -MacAddress $mac -Operation Add -XMCFQDN $server -TargetGroup $targgroup -Token $token
    #>

    [CmdletBinding()]
    param (
        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter target group: ", Position = 0)]
        [String]
        $TargetGroup,

        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter Mac Address:", Position = 1)]
        [String]
        $MacAddress,

        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Choose operation type:", Position = 2)]
        [ValidateSet("Add", "Remove")]
        $OperationType,

        [Parameter(valuefrompipeline = $true, HelpMessage = "Enter access token for the API:", Position = 3)]
        [XMCSession]
        $Token,

        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter XMC Server address:", Position = 4)]
        [String]
        $XMCFQDN,

        [Parameter(valuefrompipeline = $true, HelpMessage = "Enter description", Position = 5)]
        [String]
        $Description = "Added with PowerShell at $(get-date -Format "dd.MM.yy HH:mm:ss")"

    )

    Begin {

        $headers = @{
            "Accept"        = "application/json"
            "Cache-Control" = "no-cache"
        }

        if ($null -eq $Token) {

            $headers.Add("Authorization", "Bearer $($global:XMCSession.token)")

        }

        $uri = "https://$XMCFQDN/nbi/graphql"

    }
    Process {

        if ($OperationType -eq "Add") {
            # Add Mac Address
            $Operation = "addEntryToGroup"
            $prepo = "to"
            $GraphQLQuery = "mutation { accessControl {$Operation (input:{group:""$targetGroup"",value:""$macAddress"",description:""$description"",reauthenticate:false}) { clientSessionId errorCode message name operationId status }} }"
        }
        elseif ($OperationType -eq "Remove") {
            # Remove Mac Address
            $Operation = "removeEntryFromGroup"
            $prepo = "from"
            $GraphQLQuery = "mutation { accessControl {$Operation (input:{group:""$targetGroup"",value:""$macAddress""}) { clientSessionId errorCode message name operationId status }} }"

        }

        $query = @{
            query = $GraphQLQuery
        }

        $queryJSON = $query | ConvertTo-Json

        try {    
            $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -body $queryJSON
        }
        catch {

            if ($_.Exception.Response.StatusCode.Value__ -eq 401) {

                Write-host "Warning: XMC session expired, force re-login" -ForegroundColor Yellow

                #$Token = $XMCSession.getToken()
                $headers.Authorization = "Bearer $($global:XMCSession.getToken())"
                $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -body $queryJSON
            }

        }           

        if ($response.data.accessControl.$Operation.status -eq "SUCCESS") {

            $message = "[$OperationType]" + ": Mac $macAddress $prepo $targgroup"

            Write-host $message -ForegroundColor Green
        
        }
        elseif ($response.data.accessControl.$Operation.status -eq "ERROR") {

            Write-Error $response.data.accessControl.$Operation.message

        }
    }
    End {

        return $message

    }

}