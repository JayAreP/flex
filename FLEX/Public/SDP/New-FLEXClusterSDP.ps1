function New-FLEXClusterSDP {
    param(
        [parameter(Mandatory)]
        [string] $name,
        [parameter()]
        [ValidateSet('40k','80k')]
        [string] $Pv2,
        [parameter(Mandatory)]
        [ValidateSet(2,3,4,5,6,7,8)]
        [int] $cnodes,
        [parameter()]
        [ValidateSet(2,3,4,5,6,7,8)]
        [int] $minCnodes = $cnodes,
        [parameter(Mandatory)]
        [ValidateSet('Large','Medium', 'Small', 'P5', 'P10', 'P20', 'P40', 'P80', IgnoreCase = $false)]
        [string] $mnodeSize,
        [parameter()]
        [switch] $whatif,
        [parameter()]
        [switch] $wait,
        [parameter()]
        [switch] $iscsiOnMgmt,
        [parameter()]
        [switch] $enableCheckPointing,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    # Validate params
    $Pv2Sizes = @('P5', 'P10', 'P20', 'P40', 'P80')
    $Pv2SizeArray = @{}
    $Pv2SizeArray.Add('P5','disks_5tib')
    $Pv2SizeArray.Add('P10','disks_10tib')
    $Pv2SizeArray.Add('P20','disks_20tib')
    $Pv2SizeArray.Add('P40','disks_40tib')
    $Pv2SizeArray.Add('P80','disks_80tib')

    $Pv2IOPSArray = @{}
    $Pv2IOPSArray.Add('40k','40000')
    $Pv2IOPSArray.Add('80k','80000')

    $LS3Sizes = @('Large','Medium', 'Small')

    if ($Pv2) {
        if ($Pv2Sizes -contains $mnodeSize) {   
            $mnodeSize = $Pv2SizeArray[$mnodeSize]
        } else {
            $err = "Please specify a P-series size for Pv2 -mnodeSize"
            return $err | Write-Error
        }
    } elseif ($LS3Sizes -notcontains $mnodeSize) {
        $err = "Please specify either Small, Medium, or Large for L-series -mnodeSize"
        return $err | Write-Error
    }

    # body building

    $flexCluster = Get-FLEXCluster -flexContext $flexContext
    $flexParams = Get-FLEXClusterParameters -flexContext $flexContext

    $endpoint = 'clusters/' + $flexCluster.id + '/sdps'

    $netArray = New-Object psobject

    $netArray | Add-Member -MemberType NoteProperty -Name "dns_srvs" -Value $flexParams.netconf.dns_srvs
    $netArray | Add-Member -MemberType NoteProperty -Name "ntp_srvs" -Value $flexParams.netconf.ntp_srvs
    $netArray | Add-Member -MemberType NoteProperty -Name "default_gw" -Value $flexParams.netconf.default_gw
    $netArray | Add-Member -MemberType NoteProperty -Name "system_ip" -Value $null
    $netArray | Add-Member -MemberType NoteProperty -Name "netmask" -Value $flexParams.netconf.netmask

    # Produce the final payload
    $finalBody = New-Object psobject

    $finalBody | Add-Member -MemberType NoteProperty -Name "admin_password" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "admin_password_confirm" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "security_password" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "security_password_confirm" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "viewer_password" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "viewer_password_confirm" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "replication_password" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "replication_password_confirm" -Value $flexParams.admin_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "company_name" -Value $flexParams.company_name
    $finalBody | Add-Member -MemberType NoteProperty -Name "syslog_srv" -Value $flexParams.syslog_srv
    $finalBody | Add-Member -MemberType NoteProperty -Name "smtpconf" -Value $flexParams.smtpconf
    $finalBody | Add-Member -MemberType NoteProperty -Name "netconf" -Value $netArray
    $finalBody | Add-Member -MemberType NoteProperty -Name "dns_srvs" -Value @{}
    $finalBody | Add-Member -MemberType NoteProperty -Name "ntp_srvs" -Value @{}
    if ($iscsiOnMgmt) {
        $finalBody | Add-Member -MemberType NoteProperty -Name "iscsi_over_mgmt" -Value $true
    } else {
        $finalBody | Add-Member -MemberType NoteProperty -Name "iscsi_over_mgmt" -Value $flexParams.iscsi_over_mgmt 
    }
    
    $finalBody | Add-Member -MemberType NoteProperty -Name "k2_name" -Value $name
    $finalBody | Add-Member -MemberType NoteProperty -Name "cluster_id" -Value $null

    if ($enableCheckPointing) {
        $finalBody | Add-Member -MemberType NoteProperty -Name "enabled_checkpointing" -Value $true
    } else {
        $finalBody | Add-Member -MemberType NoteProperty -Name "enabled_checkpointing" -Value $false
    }

    $cnodeBody = New-Object psobject
    $cnodeBody | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "Production"
    $cnodeBody | Add-Member -MemberType NoteProperty -Name "amount" -Value $cnodes

    $mnodeBody = New-Object psobject
    $mnodeBody | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value $mnodeSize
    $mnodeBody | Add-Member -MemberType NoteProperty -Name "amount" -Value 1

    $finalBody | Add-Member -MemberType NoteProperty -Name "cnodes" -Value @($cnodeBody)
    $finalBody | Add-Member -MemberType NoteProperty -Name "mnodes" -Value @($mnodeBody)
    $finalBody | Add-Member -MemberType NoteProperty -Name "min_cnodes" -Value $minCnodes

    if ($Pv2) {
        $finalBody | Add-Member -MemberType NoteProperty -Name "single_cnode_iops" -Value $Pv2IOPSArray[$Pv2]
    }  else {
        $finalBody | Add-Member -MemberType NoteProperty -Name "single_cnode_iops" -Value 0
    }
    
    # Submit the call 
    if ($whatif) {
        $endpoint | Write-Host -ForegroundColor yellow
        $finalBody | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor yellow
    } else {
        $results = Invoke-FLEXRestCall -method POST -API v2 -endpoint $endpoint -body $finalBody -flexContext $flexContext
        if ($wait) {
            Write-FLEXProgress -message "Creating SDP - $name"
        }
        return $results._obj
    }
}