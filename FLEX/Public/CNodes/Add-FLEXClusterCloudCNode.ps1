function Add-FLEXClusterCloudCNode {
    param(
        [parameter()]
        [switch] $wait,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'add_and_install_cloud_nodes' 
        $api = 'v1'
        $cluster = Get-FLEXCluster
        if (!$cluster.id) {
            $err = "No cluster discovered, please first connect to FLEX using Connect-FLEX"
            $err | Write-Error
            exit
        }
    }

    process {
        $o = New-Object psobject
        if ($id) {
            $o | Add-Member -MemberType NoteProperty -Name "cluster_id" -Value $id
        } else {
            $o | Add-Member -MemberType NoteProperty -Name "cluster_id" -Value $cluster.id
        }
        
        if ($cluster.cluster_type -eq "GCP") {
            $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "Production"
            $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '60 vCPU 240GB'
        }
        elseif ($cluster.cluster_type -eq "AWS") {
            $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "Production"
            $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '64 vCPU 256GB'
        }
        elseif ($cluster.cluster_type -eq "AZURE") {            
            $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "Production"
            $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '64 vCPU 256GB'
        }
                
        $body = New-Object psobject 
        $body | Add-Member -MemberType NoteProperty -Name 'cnodes' -Value @($o)
        $body | Add-Member -MemberType NoteProperty -Name 'mnodes' -Value @()

        $results = Invoke-FLEXRestCall -method POST -endpoint $endpoint -API $api -body $body
        if ($wait) {
            Write-FLEXProgress -message "Generating node(s) "
            $results = Convert-FLEXResults -resultsObject $results -object items
            return $results
        } else { 
            $results = Convert-FLEXResults -resultsObject $results -object items
            return $results
        }        
    }
}

