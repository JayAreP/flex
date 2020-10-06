function Add-FLEXClusterCloudCNode {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
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

        $body = New-Object psobject 
        $body | Add-Member -MemberType NoteProperty -Name 'cnodes' -Value @($o)
        $body | Add-Member -MemberType NoteProperty -Name 'mnodes' -Value @()

        Invoke-FLEXRestCall -method POST -endpoint $endpoint -API $api -body $body
    }
}

