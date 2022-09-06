class FlexSDP {
    [string] $name
    [string] $id
    [string] $cluster_id
    [string] $version
    [string] $customer
    [string] $k2_id
    [string] $iops_max
    [string] $throughput_max
    [string] $min_cnodes
    [string] $max_cnodes
    [string] $min_mnodes
    [string] $max_mnodes
    [string] $iscsi_over_mgmt
    [string] $mc_floating_ip
    [string] $mc_https_port
    [string] $mc_url
    [string] $state
    [string] $flex_k2_state
    [array] $cnodes
    [array] $mnodes
    [array]scaleUp ([int]$cnodes) {
        # generate the nodes if required
        # $currentCnodes = $this.cnodes.Count
        $freeCnodes = Get-FLEXClusterCNodes -showAvailable
        if ($freeCnodes) {
            $freeCount = $freeCnodes.count
        } else {
            $freeCount = 0
        }

        $cnodeDelta = $freeCount - $cnodes
        if ($cnodeDelta -lt $cnodes) {
            $requiredCnodes = $cnodes - $freeCount
            $addCounter = 0
            while ($addCounter -lt $requiredCnodes) {
                Add-FLEXClusterCloudCNode -wait
                $addCounter++
                $freeCnodes = Get-FLEXClusterCNodes -showAvailable
            }
        } 

        $scaleCounter = 0
        while ($scaleCounter -lt $cnodes) {
            Move-FLEXClusterCNode -id $freeCnodes[0].id -targetName $this.name -wait
            $scaleCounter++
            $freeCnodes = Get-FLEXClusterCNodes -showAvailable
        }

        
        # Update $this 
        $thisSDP = Get-FLEXClusterSDP -name $this.name
        return $thisSDP
    }
}


function Get-FLEXClusterSDP {
    param(
        [parameter()]
        [string] $name,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $flexTopology = Get-FLEXDashboard -flexContext $flexContext
    $results = $flexTopology.k2xs

    if ($name) {
        $results = $results | where-object {$_.name -eq $name}
    }

    $returnArray = @()

    foreach ($i in $results) {
        $classObj = [FlexSDP]::new()
        $classObj.name = $i.name
        $classObj.id = $i.id
        $classObj.cluster_id = $i.cluster_id
        $classObj.version = $i.version
        $classObj.customer = $i.customer
        $classObj.k2_id = $i.k2_id
        $classObj.iops_max = $i.iops_max
        $classObj.throughput_max = $i.throughput_max
        $classObj.min_cnodes = $i.min_cnodes
        $classObj.max_cnodes = $i.max_cnodes
        $classObj.min_mnodes = $i.min_mnodes
        $classObj.max_mnodes = $i.max_mnodes
        $classObj.iscsi_over_mgmt = $i.iscsi_over_mgmt
        $classObj.mc_floating_ip = $i.mc_floating_ip
        $classObj.mc_https_port = $i.mc_https_port
        $classObj.mc_url = $i.mc_url
        $classObj.state = $i.state
        $classObj.flex_k2_state = $i.flex_k2_state
        $classObj.cnodes = $i.cnodes
        $classObj.mnodes = $i.mnodes

        $returnArray += @($classObj)
    }

    return $returnArray

}
