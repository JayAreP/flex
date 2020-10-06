function Add-FLEXClusterCloudCNode {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [int] $count = 1,
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
        $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "Production"
        $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '64 vCPU 256GB'

        $totalCNodes = @()

        $total = 0
        while ($total -lt $count) {
            $totalCNodes += $o
            $total++
        }

        $body = New-Object psobject 
        $body | Add-Member -MemberType NoteProperty -Name 'cnodes' -Value @($totalCNodes)
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

