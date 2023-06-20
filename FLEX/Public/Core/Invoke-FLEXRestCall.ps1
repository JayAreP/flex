function Invoke-FLEXRestCall {
    param(
        [parameter(Mandatory)] 
        [ValidateSet('GET','POST','PATCH','DELETE')]
        [string] $method,
        [parameter(Mandatory)] 
        [ValidateSet('v1','v2', IgnoreCase = $false)]
        [string] $API,
        [parameter(Mandatory)] 
        [string] $endpoint,
        [parameter()] 
        [PSCustomObject] $body,
        [parameter()] 
        [string] $outfile,
        [parameter()]
        [string] $flexContext = 'FLEXConnect',
        [parameter()]
        [int] $timeout = 120
    )

    <#
    .DESCRIPTION
        Customer REST handler for the Silk FLEX API

    .SYNOPSIS 
        Use this function to invoke simple API calls against an existing Silk FLEX deployment. Must first connect using Connect-FLEX. 

    .EXAMPLE
        Invoke-FLEXRestCall -Method GET -API v1 -endpoint 'me/topology'
    #>

    # Check Token expiration. 

    $context = Get-Variable -Scope Global -Name $flexContext -ValueOnly

    $dateNow = get-date
    $dateToken = get-date $context.token.expiresOn
    if ($dateNow -gt $dateToken) {
        $err = "Login session has expired, please reconnect with Connect-FLEX" 
        return $err | Write-Error
    }

    $token = $context.token.access_token
    $baseURI = 'https://' + $context.FLEXEndpoint + '/api/' + $API + '/' + $endpoint 
    $verboseResponse = "Final request URI --- " + $baseURI
    Write-Verbose $verboseResponse

    $header = New-FLEXAPIHeader -token $token -post
    # $postheader = New-FLEXAPIHeader -token $token -post
    $header | Convertto-json | Write-Verbose

    # $securetoken = $token | ConvertTo-SecureString -Force -AsPlainText
    if ($PSVersionTable.PSEdition -eq 'Core') {
        if ($body) {
            $bodyjson = $body | ConvertTo-Json -Depth 10
            $bodyjson | Write-Verbose
            $result = Invoke-RestMethod -header $header -Method $method -Uri $baseURI -TimeoutSec $timeout -SkipCertificateCheck -Body $bodyjson
        } elseif ($outfile) {
            Invoke-RestMethod -header $header -Method $method -Uri $baseURI -TimeoutSec $timeout -SkipCertificateCheck -OutFile $outfile
            $result = $outfile
        } else {
            $result = Invoke-RestMethod -header $header -Method $method -Uri $baseURI -TimeoutSec $timeout -SkipCertificateCheck
        }
    } elseif ($PSVersionTable.PSEdition -eq 'Desktop') {
        if ([System.Net.ServicePointManager]::CertificatePolicy -notlike 'TrustAllCertsPolicy') { 
            Write-Verbose "Correcting certificate policy"
            Unblock-CertificatePolicy
        }
        if ([Net.ServicePointManager]::SecurityProtocol -notmatch 'Tls12') {
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol + 'Tls12'
        }
        if ($body) {
            $bodyjson = $body | ConvertTo-Json -Depth 10
            $bodyjson | Write-Verbose
            $result = Invoke-RestMethod -header $header -Method $method -Uri $baseURI -Body $bodyjson
        } elseif ($outfile) {
            Invoke-RestMethod -header $header -Method $method -Uri $baseURI -TimeoutSec $timeout -OutFile $outfile
            $result = $outfile
        } else {
            $result = Invoke-RestMethod -header $header -Method $method -Uri $baseURI 
        }

        $result = @($result)
    }

    return $result
}