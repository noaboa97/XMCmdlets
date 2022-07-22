function Get-XMCToken {
    <#
    .SYNOPSIS
    Retrieves the XMC API token
    .DESCRIPTION
    Retrieves the XMC API token and creates a session to use. Session is saved in a global variable $XMCSession.
    also returns the session and could be passed as parameter to the Update-XMCAccessControlGroups.

    .PARAMETER ClientID
    ClientID from the Client API Access User

    .PARAMETER ClientSecret
    ClientSecret from the Client API Access User

    .PARAMETER XMCFQDN
    Extreme Cloud IQ Site Engine URL with Port
    
    .OUTPUTS
    XMC Session object

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  11.07.2022
    Purpose/Change: Initial function development
  
    .EXAMPLE
    $clientid = "YourClientID"
    $clientsecret = "YourClientSecret"
    $server = "Hostname:Port"

    Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server

    .EXAMPLE
    $token = Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server
    #>

    [CmdletBinding()]
    param (
        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter XMC Client ID:", Position = 0)]
        [String]
        $ClientID,

        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter XMC Client Secret:", Position = 1)]
        [String]
        $ClientSecret,

        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter XMC Server address", Position = 2)]
        [String]
        $XMCFQDN
    )

    $global:XMCSession = [XMCSession]::new()

    $XMCSession.requestToken($XMCFQDN, $ClientID, $ClientSecret)

    return $XMCSession

}