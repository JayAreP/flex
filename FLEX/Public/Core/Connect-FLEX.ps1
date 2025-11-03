<#
    .SYNOPSIS
    Function for connecting to a Flex deployment with this SDK.

    .DESCRIPTION
    This is the required first-run function to establish a session to an existing Flex deployment

    .PARAMETER Server
    [string] - Management IP or name for the Flex console.

    .PARAMETER credentials
    [pscredential] - Credential used to authenticate to flex.

    .PARAMETER flexContext
    [string] - Allows you to set a specific context when connecting to flex. Useful when connecting to multiple instances of flex.

    .PARAMETER skipVersionChecks
    [switch] - Skip the built in version validation between this SDK and the target Flex deployment.

    .EXAMPLE
    $creds = Get-Credential
    Connect-Flex -Server 10.30.51.11 -credentials $creds

    .LINK
    https://github.com/JayAreP/flex
#>
function Connect-FLEX {
    [CmdletBinding(DefaultParameterSetName = 'credentials')]
    param(
        [parameter(Mandatory = $true, ParameterSetName = 'credentials')]
        [PSCredential] $credentials,
        [parameter(Mandatory = $true, ParameterSetName = 'token')]
        [string] $token,
        [parameter(Mandatory)]
        [string] $server,
        [parameter()]
        [switch] $skipVersionChecks,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"

    if ($PSCmdlet.ParameterSetName -eq 'credentials') {
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
    }

    if ($PSCmdlet.ParameterSetName -eq 'token') {
        $expiresOn = (get-date).AddYears(100)
        $response = New-Object psobject
        $response | Add-Member -MemberType NoteProperty -Name 'access_token' -Value $token
        $response | Add-Member -MemberType NoteProperty -Name 'expiresOn' -Value $expiresOn.ToString()
    }

    # Store in Global var scope. 
    $o = New-Object psobject
    $o | Add-Member -MemberType NoteProperty -Name 'token' -Value $response
    $o | Add-Member -MemberType NoteProperty -Name 'FLEXEndpoint' -Value $server
    if ($skipVersionChecks) {
        $o | Add-Member -MemberType NoteProperty -Name 'SkipVersionCheck' -Value $true
    } else {
        $o | Add-Member -MemberType NoteProperty -Name 'SkipVersionCheck' -Value $false
    }

    Set-Variable -Name $flexContext -Value $o -Scope Global

    $version = Get-FLEXVersion
    $o | Add-Member -MemberType NoteProperty -Name 'version' -Value $version
    $cluster = Get-FLEXCluster
    $o | Add-Member -MemberType NoteProperty -Name 'cloud' -Value $cluster.cluster_type
    Set-Variable -Name $flexContext -Value $o -Scope Global

    return $o
}

