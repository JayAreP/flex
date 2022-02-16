function Get-FLEXVersion {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = "version"
    }

    process {
        $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint $endpoint -flexContext 'flexconnect'
        return $results.version
    }
}