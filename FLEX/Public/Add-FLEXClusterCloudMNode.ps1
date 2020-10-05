function Add-FLEXClusterCloudCNode {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $id,
        [parameter(Mandatory)]
        [ValidateSet('Prd50TB', 'Prd24TB', 'Prd12TB', IgnoreCase = $false)]
        [string] $nodeSize,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'add_and_install_cloud_nodes'
        $api = 'v1'
    }

    process {

        $o = New-Object PSObject
        $o | Add-Member -MemberType NoteProperty -Name "cluster_id" -Value $id
        $o | Add-Member -MemberType NoteProperty -Name "node_type" -Value "mnode"
        $o | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $nodeSize
        # $nodeIndex = query nodes and add +1 for node_index tally
        $o | Add-Member -MemberType NoteProperty -Name "node_index" -Value 
        $nodeId = 'flex-cluster-' + $id + '-' + $nodeType + '-' + $nodeIndex
        $o | Add-Member -MemberType NoteProperty -Name "node_id" -Value $nodeId
        # query node size somehow to add friendly name
        $o | Add-Member -MemberType NoteProperty -Name "friendly_name" -Value $null

        $results = Invoke-FLEXRestCall -method POST -API $api -endpoint $endpoint -body $o -flexContext $flexContext

        return $results
    }



}