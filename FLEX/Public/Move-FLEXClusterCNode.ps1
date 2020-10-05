function Move-FLEXClusterCNode {
    param(
        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string] $id,
        [parameter()]
        [string] $sourceName = "Free Pool",
        [parameter()]
        [string] $targetName = "Free Pool",
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        $endpoint = 'tasks/move-nodes'
        $api = 'v1'
    }

    process {

        $cnodeSrc = Get-FLEXClusterCNodes | Where-Object {$_.id -eq $id}

        $cnode = New-Object psobject

        if ($sourceName -ne "Free Pool") {
            $sourceSDP = Get-FLEXClusterSDP -name $sourceName
            $cnode | Add-Member -MemberType NoteProperty -Name "src_k2_id" -Value $sourceSDP.id
        } else {
            $cnode | Add-Member -MemberType NoteProperty -Name "src_k2_id" -Value $null
        }

        $cnode | Add-Member -MemberType NoteProperty -Name "src_k2_name" -Value $sourceName

        if ($targetName -ne "Free Pool") {
            $targetSDP = Get-FLEXClusterSDP -name $targetName
            $cnode | Add-Member -MemberType NoteProperty -Name "tgt_k2_id" -Value $targetSDP.k2_id
        } else {
            $cnode | Add-Member -MemberType NoteProperty -Name "tgt_k2_id" -Value $null
        }

        $cnode | Add-Member -MemberType NoteProperty -Name "tgt_k2_name" -Value $targetName
        $cnode | Add-Member -MemberType NoteProperty -Name "cnode_id" -Value $cnodeSrc.id
        $cnode | Add-Member -MemberType NoteProperty -Name "cnode_name" -Value $cnodeSrc.name

        $flexCluster = Get-FLEXCluster

        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name "cluster_id" -Value $flexCluster.id
        $o | Add-Member -MemberType NoteProperty -Name "cnodes" -Value @($cnode)

        $results = Invoke-FLEXRestCall -method POST -API $api -endpoint $endpoint -body $o -flexContext $flexContext

        return $results
    }
}