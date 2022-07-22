class XMCSession {
    #base URI for API calls
    [string]$Server

    hidden [string]$Token

    [datetime]$LastUsed

    [int]$TimeToLive = 600

    hidden [string]$ClientID

    hidden [string]$ClientSecret

    requestToken ($Server, $ClientID, $ClientSecret) {
        #logic to retrieve key here
        $Uri = 'https://{0}/oauth/token/access-token?grant_type=client_credentials' -f $Server

        $this.Server = $Server

        $this.ClientID = $ClientID

        $this.ClientSecret = $ClientSecret

        #Encoding of the client data
        $IDSecret = $ClientID + ":" + $ClientSecret 
        $EncodedIDSecret = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($IDSecret))

        $headers = @{
            "Authorization" = "Basic $EncodedIDSecret"
            
        }
            
        # Maybe add some error handling
        $response = Invoke-WebRequest -uri $Uri -headers $headers -Method Post -ContentType "application/x-www-form-urlencoded"

        $this.LastUsed = [datetime]::Now

        # return token as a string
        $this.token = ($response.content | convertfrom-json).access_token
    }

    [string] getToken () {
        if ( ([datetime]::Now - $this.LastUsed).TotalSeconds -gt $this.TimeToLive ) {
            $this.requestToken($this.Server, $this.ClientID, $this.ClientSecret)

            Write-Host "New session token requested"

        }
        return $this.token
    }

}