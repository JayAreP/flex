function Remove-FLEXClusterSDP {
    param(
        [parameter(Mandatory)]
        [string] $sdpName,
        [parameter()]
        [switch] $confirm,
        [parameter()]
        [switch] $force,
        [parameter()]
        [switch] $wait,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $flexCluster = Get-FLEXCluster -flexContext $flexContext
        
        if (!$flexCluster.id) {
            $err = "No cluster discovered, please first connect to FLEX using Connect-FLEX"
            $err | Write-Error
            exit
        }

        $flexSDP = Get-FLEXClusterSDP -name $sdpName -flexContext $flexContext
        if (!$flexSDP.id) {
            $err = "No SDP discovered, pleae check the value for sdpName"
            $err | Write-Error
            exit
        }

        $endpoint = 'clusters/' + $flexCluster.id + '/sdps/' + $flexSDP.id
        $api = 'v2'
    }
    

    process {
        if ($confirm) {
            if (!$force) {
                $o | Out-Host
                Write-Host "-- Deleting this SDP in 30 seconds..."`n`n
                Start-Sleep -Seconds 30
            }   
            $results = Invoke-FLEXRestCall -method DELETE -API $api -endpoint $endpoint -flexContext $flexContext
        } else {
            $err = "-- Please specify -confirm."
            return $err | Write-Error
        }

        if ($wait) {
            Write-FLEXProgress -message "Removing SDP - $name" -flexContext $flexContext
        }
        return $results
    }

}



