function Add-FLEXClusterCloudMNode {
    param(
        [parameter()]
        [switch] $wait,
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet('Large','Medium', 'Small', IgnoreCase = $false)]
        [string] $size,
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
        elseif ($cluster.cluster_type -eq "AWS") {
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
        elseif ($cluster.cluster_type -eq "AZURE") {
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
                
        $body = New-Object psobject 
        $body | Add-Member -MemberType NoteProperty -Name 'cnodes' -Value @()
        $body | Add-Member -MemberType NoteProperty -Name 'mnodes' -Value @($o)

        $results = Invoke-FLEXRestCall -method POST -endpoint $endpoint -API $api -body $body
        if ($wait) {
            Write-FLEXProgress -message "Generating node(s) "
            return $results
        } else { 
            return $results.items
        }   
    }
}

