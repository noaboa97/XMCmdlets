function Get-XMCEndSystemsOfGroup {
    <#
    .SYNOPSIS
    Retrieves all end systems of a group
    .DESCRIPTION
    Retrieves all end systems of a group

    .PARAMETER Group
    Group that contains the endsystem which should be retrieved

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
    Creation Date:  13.12.2022
    Purpose/Change: Initial function development
  
    .EXAMPLE
    $server = "Hostname:Port"
    $group = "YourAccessControlGroup" #e.g. SwissTPH-StagingDevices

    $resp = Get-XMCEndSystemsOfGroup -Group $group -XMCFQDN $server -token $xmcsession

    .EXAMPLE
    $resp = Get-XMCEndSystemsOfGroup -Group "YourAccessControlGroup" -XMCFQDN $server -token $xmcsession
    #>

    [CmdletBinding()]
    param (
        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter target group: ", Position = 0)]
        [String]
        $Group,

        [Parameter(valuefrompipeline = $true, HelpMessage = "Enter access token for the API:", Position = 1)]
        [XMCSession]
        $Token,

        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter XMC Server address:", Position = 2)]
        [String]
        $XMCFQDN

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

        $GraphQLQuery = "query { accessControl { group(name: ""$Group"") { description typeStr name values valueDescriptions } } }"

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

                $headers.Authorization = "Bearer $($global:XMCSession.getToken())"
                $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -body $queryJSON
            }

        }           
        
        if ($null -eq $response.data.accessControl.group) {

            Write-Error "Group not found" -ErrorAction Stop
        
        }
        elseif ([bool]$response.errors) {

            Write-Error "Other error occured"
            Write-host $response.errors -ForegroundColor Red
            return

        }

        $values = $response.data.accessControl.group.values
        $description = $response.data.accessControl.group.valueDescriptions
        
        $table = @()

        $i = 0
        while ($i -ne $values.length) {

            Write-Verbose "Adding $($values[$i]) with description: $($description[$i]) to array"
            $table += New-Object -TypeName psobject -Property @{Mac=$values[$i]; Description=$description[$i]}
            $i++
        }

    }
    End {

        return $table

    }

}