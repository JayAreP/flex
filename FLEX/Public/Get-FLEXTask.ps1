function Get-FLEXTask {
    param(
        [parameter()]
        [string] $taskID
    )

    $endpoint = 'tasks'
    $API = 'v1'

    if ($taskID) {
        $endpoint = $endpoint + '/' + $taskID
    }

    $results = Invoke-FLEXRestCall -method GET -API $api -endpoint $endpoint

    return $results.hits
}