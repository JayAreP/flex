function Add-FLEXClusterCloudMNode {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet('GCP','AWS', 'Azure', IgnoreCase = $false)]
        [string] $cluster_type,
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet('Large','Medium', 'Small', IgnoreCase = $false)]
        [string] $size,
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
            if ($size = 'Small') {
                $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $size
                $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '11.29TiB total'
            } elseif ($size = 'Medium') {
                $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $size
                $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '22.86TiB total'
            } elseif ($size = 'Large') {
                $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $size
                $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '45.97TiB total'
            }
        }
        elseif ($cluster_type -eq "AWS") {
            if ($size = 'Small') {
                $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $size
                $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value 'Prd19TiB'
            } elseif ($size = 'Medium') {
                $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $size
                $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value 'Prd38.2TiB'
            } elseif ($size = 'Large') {
                $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $size
                $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value 'Prd76TiB'
            }
        }
        elseif ($cluster_type -eq "Azure") {
            if ($size = 'Small') {
                $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $size
                $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '27.32TiB total'
            } elseif ($size = 'Medium') {
                $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $size
                $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '54.88TiB total'
            } elseif ($size = 'Large') {
                $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $size
                $o | Add-Member -MemberType NoteProperty -Name 'friendly_name' -Value '102.4TiB total'
            }
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
        $body | Add-Member -MemberType NoteProperty -Name 'cnodes' -Value @()
        $body | Add-Member -MemberType NoteProperty -Name 'mnodes' -Value @($o)

        $results = Invoke-FLEXRestCall -method POST -endpoint $endpoint -API $api -body $body
        if ($wait) {
            $task = $results.items.id
            Write-FLEXProgress -taskID $task -message "Creating m-node"
            return $results
        } else {
            return $results
        }
        
    }
}

