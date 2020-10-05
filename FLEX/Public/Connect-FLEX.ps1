function Connect-FLEX {
    param(
        [parameter(Mandatory)]
        [PSCredential] $credentials,
        [parameter(Mandatory)]
        [string] $server,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'

    )
    <#
    .DESCRIPTION
        Function for connecting to a Silk FLEX deployment

    .SYNOPSIS
        This function allows you to connect to a flex deployment using a standard PowerSHell credential object. 
    
    .EXAMPLE
        $creds = get-credential
        Connect-FLEX -server 104.34.19.202 -credentials $creds
    
    #>

    $body = New-Object -TypeName PSObject
    $body | Add-Member -MemberType NoteProperty -Name 'username' -Value $credentials.UserName
    $body | Add-Member -MemberType NoteProperty -Name 'password' -Value $credentials.GetNetworkCredential().password

    $bodyString = 'password=' + $credentials.GetNetworkCredential().password + '&username=' + $credentials.UserName

    # Replace with proper REST function at some point...
    $fullURI = 'https://' + $server + '/api/v1/auth/local/login'

    if ($PSVersionTable.PSEdition -eq 'Core') {
        $response = Invoke-RestMethod -SkipCertificateCheck -Method POST -Uri $fullURI -Body $bodyString
    } elseif ($PSVersionTable.PSEdition -eq 'Desktop') {
        if ([System.Net.ServicePointManager]::CertificatePolicy -notlike 'TrustAllCertsPolicy') { 
            Write-Verbose "Correcting certificate policy"
            Unblock-CertificatePolicy
        }
        if ([Net.ServicePointManager]::SecurityProtocol -notmatch 'Tls12') {
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol + 'Tls12'
        }
        $response = Invoke-RestMethod -Method POST -Uri $fullURI -Body $bodyString
    }

    # Store in Global var scope. 
    $o = New-Object psobject
    $o | Add-Member -MemberType NoteProperty -Name 'token' -Value $response
    $o | Add-Member -MemberType NoteProperty -Name 'FLEXEndpoint' -Value $server

    Set-Variable -Name $flexContext -Value $o -Scope Global

    return $response
}

