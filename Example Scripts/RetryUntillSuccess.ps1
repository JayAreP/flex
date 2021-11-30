param(
    [int] $retries = 20
)

# Infer the cluster specs
try {
    $cluster = Get-FLEXCluster
} catch {
    Write-Host "Please first connect to flex using Connect-FLEX" -ForegroundColor Yellow
    exit
}

$clusterType = $cluster.cluster_type.Substring(0,1)+$cluster.cluster_type.substring(1).tolower()

# Start the retry look with a first attempt
Add-FLEXClusterCloudMNode -id $cluster.id -cluster_type $clusterType -size Small
Start-Sleep -Seconds 300

$mnode = Get-FLEXClusterMNodes -showAvailable | Where-Object {$_.state -eq "MALFUNCTION"}

$attempt = 1
if ($mnode) {
    while ($attempt -lt $retries) {
        # Remove the defunct mnode
        Get-FLEXClusterMNodes -showAvailable | Where-Object {$_.state -eq "MALFUNCTION"} | Remove-FLEXClusterCloudMNode

        # Check the flex task
        $tasks = Get-FLEXTask
        $lastTask = $tasks[-1]
        while ($lastTask.state -ne 'completed') {
            # Keep checking until the removal is complete
            Start-Sleep -Seconds 10
            $tasks = Get-FLEXTask
            $lastTask = $tasks[-1]
        }
        # Once the removal is complete, try to add an MNode again and then sleep for 5 minutes.
        Add-FLEXClusterCloudMNode -id $cluster.id -cluster_type $clusterType -size Small
        Start-Sleep -Seconds 300
        $attempt++
    }
}
