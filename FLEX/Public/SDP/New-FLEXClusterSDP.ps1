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
        [switch] $whatif,
        [parameter()]
        [switch] $wait,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $versionStepping = Get-FLEXVersion -majorOnly

    # body building

    $flexCluster = Get-FLEXCluster -flexContext $flexContext
    $flexNetwork = Get-FLEXClusterNetwork -flexContext $flexContext
    [ipaddress] $mgmtNetwork = $flexNetwork.external_mgmt.Split('/')[0]
    $flexParams = Get-FLEXClusterParameters -flexContext $flexContext
    $flexSDPs = Get-FLEXClusterSDP -flexContext $flexContext
    $ipRange = $flexSDPs.count + 13
    [ipaddress] $systemIPBase = "0.0.0.$ipRange"
    [ipaddress] $systemIP = Add-IPAddress -source $mgmtNetwork -delta $systemIPBase

    # Get list of cnodes

    if ($generateNodes) {
        $cnodeCounter = 1
        while ($cnodeCounter -le $cnodes) {
            Write-Verbose "-- Creating cnode $cnodeCounter"
            Add-FLEXClusterCloudCNode -flexContext $flexContext
            $cnodeCounter++ 
        }
        Add-FLEXClusterCloudMNode -size $mnodeSize -flexContext $flexContext
        Write-FLEXProgress -flexContext $flexContext -message "Generating nodes"
    }

    $freeCnodes = Get-FLEXClusterCNodes -flexContext $flexContext -showAvailable | Where-Object {$_.state -eq "RUNNING"}
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

    $freeMnodes = Get-FLEXClusterMNodes -flexContext $flexContext -showAvailable | Where-Object {$_.state -eq "RUNNING"} | Where-Object {$_.cloud_extra.cloud_node_type -eq $mnodeSize}
    if ($freeMnodes.Count -ge 1) {
        $mnodeList = @($freeMnodes[0].id)
    } else {
        $result = "No MNodes of the requested size are available."
        $result | Write-Error
        return $result
    }

    # carve out a k2_id for the new SDP
    <#
    if ($flexSDPs) {
        [int] $lastId = $flexSDPs[-1].k2_id 
        $lastId++
        $k2_id = $lastId.ToString()
    } else {
        $k2_id = $flexCluster.id + "01"
    }
    #>
    # create the network settings

    

    $netArray = New-Object psobject

    $netArray | Add-Member -MemberType NoteProperty -Name "dns_srvs" -Value $flexParams.netconf.dns_srvs
    $netArray | Add-Member -MemberType NoteProperty -Name "ntp_srvs" -Value $flexParams.netconf.ntp_srvs
    $netArray | Add-Member -MemberType NoteProperty -Name "default_gw" -Value $flexParams.netconf.default_gw
    if ($versionStepping -lt 4) {
        $netArray | Add-Member -MemberType NoteProperty -Name "system_ip" -Value $null
    } else {
        $netArray | Add-Member -MemberType NoteProperty -Name "system_ip" -Value $systemIP.IPAddressToString
    }
    $netArray | Add-Member -MemberType NoteProperty -Name "netmask" -Value $flexParams.netconf.netmask



    # Produce the final data clause

    $finalBody = New-Object psobject

    if ($versionStepping -lt 4) {
        $finalBody | Add-Member -MemberType NoteProperty -Name "timezone" -Value $flexCluster.timezone
        $finalBody | Add-Member -MemberType NoteProperty -Name "k2_id" -Value $null
    }
    
    
    $finalBody | Add-Member -MemberType NoteProperty -Name "admin_password" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "admin_password_confirm" -Value $flexParams.admin_password
    if ($versionStepping -ge 4) {
        $finalBody | Add-Member -MemberType NoteProperty -Name "security_password" -Value $flexParams.admin_password
        $finalBody | Add-Member -MemberType NoteProperty -Name "security_password_confirm" -Value $flexParams.admin_password
        $finalBody | Add-Member -MemberType NoteProperty -Name "viewer_password" -Value $flexParams.admin_password
        $finalBody | Add-Member -MemberType NoteProperty -Name "viewer_password_confirm" -Value $flexParams.admin_password
        $finalBody | Add-Member -MemberType NoteProperty -Name "replication_password" -Value $flexParams.admin_password
        $finalBody | Add-Member -MemberType NoteProperty -Name "replication_password_confirm" -Value $flexParams.admin_password
    }

    $finalBody | Add-Member -MemberType NoteProperty -Name "company_name" -Value $flexParams.company_name
    $finalBody | Add-Member -MemberType NoteProperty -Name "syslog_srv" -Value $flexParams.syslog_srv
    $finalBody | Add-Member -MemberType NoteProperty -Name "smtpconf" -Value $flexParams.smtpconf


    if ($versionStepping -ge 4) {
        $finalBody | Add-Member -MemberType NoteProperty -Name "dns_srvs" -Value @{}
        $finalBody | Add-Member -MemberType NoteProperty -Name "ntp_srvs" -Value @{}
        $finalBody | Add-Member -MemberType NoteProperty -Name "iscsi_over_mgmt" -Value $flexParams.iscsi_over_mgmt
    }

    $finalBody | Add-Member -MemberType NoteProperty -Name "netconf" -Value $netArray
    $finalBody | Add-Member -MemberType NoteProperty -Name "cnode_ids" -Value $cnodeList
    $finalBody | Add-Member -MemberType NoteProperty -Name "mnode_ids" -Value $mnodeList
    if ($versionStepping -ge 4) {
        $finalBody | Add-Member -MemberType NoteProperty -Name "enabled_checkpointing" -Value $flexCluster.enabled_checkpointing
    }
    $finalBody | Add-Member -MemberType NoteProperty -Name "k2_name" -Value $name
    $finalBody | Add-Member -MemberType NoteProperty -Name "cluster_id" -Value $flexCluster.id
    

    # Submit the call 
    if ($whatif) {
        $finalBody | Write-Host -ForegroundColor yellow
    } else {
        $results = Invoke-FLEXRestCall -method POST -API v1 -endpoint 'tasks/create-k2' -body $finalBody -flexContext $flexContext
        if ($wait) {
            Write-FLEXProgress -message "Creating SDP - $name"
        }
        return $results._obj
    }

}