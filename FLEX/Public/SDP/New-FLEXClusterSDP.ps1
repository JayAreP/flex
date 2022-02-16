function New-FLEXClusterSDP {
    param(
        [parameter(Mandatory)]
        [string] $name,
        [parameter(Mandatory)]
        [int] $cnodes,
        [parameter(Mandatory)]
        [ValidateSet('Large','Medium', 'Small', IgnoreCase = $false)]
        [string] $mnodeSize,
        [parameter()]
        [switch] $generateNodes,
        [parameter()]
        [switch] $wait
    )


    # body building

    $flexCluster = Get-FLEXCluster
    $flexNetwork = Get-FLEXClusterNetwork
    [ipaddress] $mgmtNetwork = $flexNetwork.external_mgmt.Split('/')[0]
    $flexParams = Get-FLEXClusterParameters
    $flexSDPs = Get-FLEXClusterSDP
    $ipRange = $flexSDPs.count + 13
    [ipaddress] $systemIPBase = "0.0.0.$ipRange"
    [ipaddress] $systemIP = Add-IPAddress -source $mgmtNetwork -delta $systemIPBase

    # Get list of cnodes

    if ($generateNodes) {
        $cnodeCounter = 1
        while ($cnodeCounter -le $cnodes) {
            Write-Verbose "-- Creating cnode $cnodeCounter"
            Add-FLEXClusterCloudCNode
            $cnodeCounter++ 
        }
        Add-FLEXClusterCloudMNode -size $mnodeSize
        Write-FLEXProgress -message "Generating nodes"
    }

    $freeCnodes = Get-FLEXClusterCNodes -showAvailable | Where-Object {$_.state -eq "RUNNING"}
    if ($freeCnodes.Count -ge $cnodes) {
        $cnodetop = $cnodes
        $cnodetop--
        $useCnodes = $freeCnodes[0 .. $cnodetop]
        $cnodeList = @($useCnodes.id)
    } else {
        $result = "Only - " + $freeCnode.Count + " - available of the - " + $cnodes + " - requested."
        $result | Write-Error
        return $result
    }

    # Get an appropriate mnode

    $freeMnodes = Get-FLEXClusterMNodes -showAvailable | Where-Object {$_.state -eq "RUNNING"} | Where-Object {$_.cloud_extra.cloud_node_type -eq $mnodeSize}
    if ($freeMnodes.Count -ge 1) {
        $mnodeList = @($freeMnodes[0].id)
    } else {
        $result = "No MNodes of the requested size are available."
        $result | Write-Error
        return $result
    }

    # carve out a k2_id for the new SDP

    if ($flexSDPs) {
        [int] $lastId = $flexSDPs[-1].k2_id 
        $lastId++
        $k2_id = $lastId.ToString()
    } else {
        $k2_id = $flexCluster.id + "01"
    }

    # create the network settings

    $netArray = New-Object psobject
    $netArray | Add-Member -MemberType NoteProperty -Name "dns_srvs" -Value $flexParams.netconf.dns_srvs
    $netArray | Add-Member -MemberType NoteProperty -Name "ntp_srvs" -Value $flexParams.netconf.ntp_srvs
    $netArray | Add-Member -MemberType NoteProperty -Name "default_gw" -Value $flexParams.netconf.default_gw
    $netArray | Add-Member -MemberType NoteProperty -Name "system_ip" -Value $systemIP.IPAddressToString
    $netArray | Add-Member -MemberType NoteProperty -Name "netmask" -Value $flexParams.netconf.netmask

    # Produce the final data clause

    $finalBody = New-Object psobject
    $finalBody | Add-Member -MemberType NoteProperty -Name "k2_name" -Value $name
    $finalBody | Add-Member -MemberType NoteProperty -Name "syslog_srv" -Value $flexParams.syslog_srv
    $finalBody | Add-Member -MemberType NoteProperty -Name "smtpconf" -Value $flexParams.smtpconf
    $finalBody | Add-Member -MemberType NoteProperty -Name "netconf" -Value $netArray 
    $finalBody | Add-Member -MemberType NoteProperty -Name "cnode_ids" -Value $cnodeList
    $finalBody | Add-Member -MemberType NoteProperty -Name "mnode_ids" -Value $mnodeList
    $finalBody | Add-Member -MemberType NoteProperty -Name "admin_password" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "timezone" -Value $flexCluster.timezone
    $finalBody | Add-Member -MemberType NoteProperty -Name "company_name" -Value $flexParams.company_name
    $finalBody | Add-Member -MemberType NoteProperty -Name "admin_password_confirm" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "k2_id" -Value $k2_id

    # Submit the call 
    $results = Invoke-FLEXRestCall -method POST -API v1 -endpoint 'tasks/create-k2' -body $finalBody
    if ($wait) {
        Write-FLEXProgress -message "Creating SDP - $name"
    }
    return $results._obj
}