function Get-FLEXDashboard {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $api = 'v1'
        $endpoint = 'pages/dashboard'
    }

    process {
        $response = Invoke-FLEXRestCall -method GET -API $api -endpoint $endpoint
        return $response
    }
}

