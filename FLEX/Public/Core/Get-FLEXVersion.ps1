function Get-FLEXVersion {
    param(
        [parameter()]
        [switch] $majorOnly,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    begin {
        $endpoint = "version"
    }

    process {
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "-> $functionName"
        
        $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint $endpoint -flexContext 'flexconnect'
        if ($majorOnly) {
            $version = $results.version
            [int]$majorVersion = $version.Split('.')[1]
            return $majorVersion
        } else {
            return $results.version
        }
    }
}