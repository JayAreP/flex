function Clear-FLEXTask {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [string] $taskID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'task4d/hide_inactive'
        $API = 'v2'
    }

    process {
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "-> $functionName"
        $idarray = @($taskID)
        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name ids -Value $idArray
        $response = Invoke-FLEXRestCall -method POST -API $API -endpoint $endpoint -body $o
        return $response
    }
}
