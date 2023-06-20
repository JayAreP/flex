function Get-FLEXClusterSDPCNode {
    param(
        [parameter()]
        [string] $sdpName,
        [parameter()]
        [string] $cnodeName,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $results = Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/nodes' -flexContext $flexContext

    $flexCluster = Get-FLEXCluster -flexContext $flexContext
    $results = ($results.clusters | Where-Object {$_.id -eq $flexCluster.id} | Select-Object cnodes).cnodes

    if ($sdpName) {
        $flexSDP = Get-FLEXClusterSDP -name $sdpName -flexContext $flexContext
        if (!$flexSDP.id) {
            $err = "No SDP discovered, pleae check the value for sdpName"
            $err | Write-Error
            exit
        }
        $results = ($results | Where-Object {$_.k2n_id -eq $flexSDP.id})
    }

    return $results
}