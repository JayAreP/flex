function Get-FLEXLogFile {
    param(
        [parameter()]
        [string] $path = '.\',
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'flex/logs'
        $api = 'v2'
    }

    Process {
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "-> $functionName"
        $date = get-date -Format FileDateTimeUniversal
        $outfile = $path + "logs-" + $date + '.tar.gz'
        Invoke-FLEXRestCall -method GET -API $api -endpoint $endpoint -outfile $outfile
    }
}