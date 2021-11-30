function Add-FLEXClusterCloudCNode {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet('GCP','AWS', 'Azure', IgnoreCase = $false)]
        [string] $cluster_type,
        [parameter()]
        [string] $flexContext = 'FLEXConnect',
        [parameter()]
        [switch] $wait
    )

    begin {
        $endpoint = 'add_and_install_cloud_nodes' 
        $api = 'v1'
    }

    process {
        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name "cluster_id" -Value $id
        if ($cluster_type -eq "GCP") {
            $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "ProductionV1"
            $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '60 vCPU 240GB'
        }
        elseif ($cluster_type -eq "AWS") {
            $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "Production"
            $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '64 vCPU 256GB'
        }
        elseif ($cluster_type -eq "Azure") {
            $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "Production"
            $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '64 vCPU 256GB'
        }
        
        <#
        $totalCNodes = @()

        $total = 0
        while ($total -lt $count) {
            $totalCNodes += $o
            $total++
        }
        #>
        
        $body = New-Object psobject 
        $body | Add-Member -MemberType NoteProperty -Name 'cnodes' -Value @($o)
        $body | Add-Member -MemberType NoteProperty -Name 'mnodes' -Value @()

        $results = Invoke-FLEXRestCall -method POST -endpoint $endpoint -API $api -body $body
        if ($wait) {
            $task = $results.items.id
            Write-FLEXProgress -taskID $task -message "Creating c-node"
            return $results
        } else {
            return $results
        }
        
    }
}

