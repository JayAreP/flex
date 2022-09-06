param(
    [int] $retries = 20
)

$attempt = 1

# Start the retry look with a first attempt
Write-Host "Attempting to create MNode"
Add-FLEXClusterCloudMNode -size Small
Start-Sleep -Seconds 300

$mnode = Get-FLEXClusterMNodes -showAvailable 

while ($attempt -lt $retries) {
    if ($mnode.state -ne 'RUNNING') {
        # Remove the defunct mnode
        Write-Host "MNode creation failed. Removing failed MNode"
        Get-FLEXClusterMNodes -showAvailable | Where-Object {$_.state -eq "MALFUNCTION"} | Remove-FLEXClusterCloudMNode

        # Wait on mnode
        Write-FLEXProgress

        # Once the removal is complete, try to add an MNode again and then sleep for 5 minutes.
        Write-Host "Recreating MNode. Attempt -" $attempt "- of -" $retries "-"
        Add-FLEXClusterCloudMNode -size Small
        Start-Sleep -Seconds 300
        $mnode = Get-FLEXClusterMNodes -showAvailable
        $attempt++
    } else {
        Write-Host "---- MNode created succesfully after -" $attempt "- tries ----"
        exit
    }    
} 