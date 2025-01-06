function Get-FLEXTaskLog {
    param(
        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string] $taskID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $versionStepping = Get-FLEXVersion -majorOnly
        if ($versionStepping -ge 3) {
            $api = 'v2'
        } else {
            $api = 'v1'
        }
    }

    Process {
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "-> $functionName"

        $versionStepping = Get-FLEXVersion -majorOnly
        if ($versionStepping -ge 3) {
            $endpoint = 'task4d/' + $taskID + '/logs'
        } else {
            $endpoint = 'tasks/' + $taskID + '/logs'
        }

        $results = Invoke-FLEXRestCall -method GET -API $api -endpoint $endpoint 
        return $results
    }
}