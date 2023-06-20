function Remove-FLEXClusterSDPCNode {
    param(
        [parameter(Mandatory)]
        [string] $sdpName,
        [parameter()]
        [string] $cnodeName,
        [parameter()]
        [switch] $whatif,
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

        $endpoint = 'clusters/' + $flexCluster.id + '/sdps/' + $flexSDP.id + '/remove_nodes_validate' 
        $endpoint2 = 'clusters/' + $flexCluster.id + '/sdps/' + $flexSDP.id + '/remove_nodes' 
        $api = 'v2'
    }

    process {

        if (!$cnodeName) {
            $cnodeName = (Get-FLEXClusterSDPCNode -sdpName $flexSDP.name | Where-Object {!$_.is_pmc -and !$_.is_smc} | Sort-Object id)[-1].id
        }

        $finalBody = New-Object psobject
        $finalBody | Add-Member -MemberType NoteProperty -Name "cnodes_ids" -Value @($cnodeName)
        $finalBody | Add-Member -MemberType NoteProperty -Name "mnodes_ids" -Value @()

        if ($whatif) {
            $endpoint | Write-Host -ForegroundColor yellow
            $finalBody | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor yellow
        } else {
            $results = Invoke-FLEXRestCall -method POST -endpoint $endpoint -API $api -body $finalBody -flexContext $flexContext

            if ($results.valid -eq $true) {
                $results = Invoke-FLEXRestCall -method POST -endpoint $endpoint2 -API $api -body $finalBody -flexContext $flexContext
            }
    
            $results = Convert-FLEXResults -resultsObject $results -includeID
            return $results
        }

    }
}

