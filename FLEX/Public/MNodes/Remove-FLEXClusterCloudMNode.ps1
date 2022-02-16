function Remove-FLEXClusterCloudMNode {
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
        $body | Add-Member -MemberType NoteProperty -Name "node_type" -Value "mnode"
        $body | Add-Member -MemberType NoteProperty -Name "node_id" -Value $id
        $body | Add-Member -MemberType NoteProperty -Name 'cluster_id' -Value $cluster_id

        $results = Invoke-FLEXRestCall -method POST -endpoint $endpoint -API $api -body $body -flexContext $flexContext

        $results = Convert-FLEXResults -resultsObject $results -includeID 
        return $results
    }
}

