function Remove-FLEXClusterCloudCNode {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $cluster_id,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'tasks/remove_from_freepool' 
        $api = 'v1'
    }

    process {
        $body = New-Object psobject
        $body | Add-Member -MemberType NoteProperty -Name "node_type" -Value "cnode"
        $body | Add-Member -MemberType NoteProperty -Name "node_id" -Value $id
        $body | Add-Member -MemberType NoteProperty -Name 'cluster_id' -Value $cluster_id

        Invoke-FLEXRestCall -method POST -endpoint $endpoint -API $api -body $body
    }
}

