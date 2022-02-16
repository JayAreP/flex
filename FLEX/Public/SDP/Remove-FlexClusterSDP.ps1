function Remove-FLEXClusterSDP {
    param(
        [parameter(Mandatory)]
        [string] $name,
        [parameter()]
        [switch] $confirm,
        [parameter()]
        [switch] $force,
        [parameter()]
        [switch] $wait
    )

    # grab the SDP info
    $clusterSDP = Get-FLEXClusterSDP | Where-Object {$_.name -eq $name}
    if ($clusterSDP) {
        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name "k2_id" -Value $clusterSDP.k2_id
        $o | Add-Member -MemberType NoteProperty -Name "k2_name" -Value $clusterSDP.name 
    } else {
        $err = "No SDP with the provided name was discovered"
        $err | Write-Error
        exit
    }

    if ($o) {
        if ($confirm) {
            if (!$force) {
                $o | Out-Host
                Write-Host "-- Deleting this SDP in 30 seconds..."`n`n
                Start-Sleep -Seconds 30
            }   
            $result = Invoke-FLEXRestCall -method POST -API v1 -endpoint 'tasks/delete-k2' -body $o
        } else {
            $result = "-- Please specify -confirm."
        }
    }
    if ($wait) {
        Write-FLEXProgress -message "Removing SDP - $name"
    }
    return $result._obj
}



