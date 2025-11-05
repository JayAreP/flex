<#
    .SYNOPSIS
    Function for Creating a standard (with dnodes) SDP.

    .DESCRIPTION
    This is the function to use to create a standard SDP. To create a Pv2 SDP, please use New-FLEXClusterPv2SDP.

    .PARAMETER name
    [string] - Management IP or name for the Flex console.

    .PARAMETER cnodes
    [int] (2,3,4,5,6,7,8) - Number of CNodes to create.

    .PARAMETER mnodeSize
    [string] ('XXLarge','XLarge','Large','Medium','Small','XSmall') - Size of the MNode to deploy with the SDP. The actual size depends on Cloud Provider. 

    .PARAMETER minCnodes
    [int] (2,3,4,5,6,7,8) - Min number of CNodes for the SDP.

    .PARAMETER readCacheEnabled
    [switch] - WHere supported, will use a special CNode that supports read caching.

    .PARAMETER whatif
    [switch] - This does not actually create an SDP, but rather shows the API payload for the SDP creation. 

    .PARAMETER wait
    [switch] - This will automatically invoke Write-FlexProgress as part of the deployment. Can be usefull when writing scripts. 

    .PARAMETER iscsiOnMgmt
    [switch] - Experiemental. Do not use. 

    .PARAMETER flexContext
    [string] - Allows you to set a specific context when connecting to flex. Useful when connecting to multiple instances of flex.

    .EXAMPLE
    New-FLEXClusterSDP -cnodes 2 -mnodeSize Small
    This will create a 2 CNode SDP with standard small MNode

    .EXAMPLE
    New-FLEXClusterSDP -cnodes 3 -mnodeSize Large -readCacheEnabled
    This will create a 3 Cnode SDP with a Large MNode configured for read cache. 

    .LINK
    https://github.com/JayAreP/flex
#>
function New-FLEXClusterSDP {
    param(
        [parameter(Mandatory)]
        [string] $name,
        [parameter(Mandatory)]
        [ValidateSet(2,3,4,5,6,7,8)]
        [int] $cnodes,
        [parameter(Mandatory)]
        [ValidateSet('XXLarge','XLarge','Large','Medium','Small','XSmall', IgnoreCase = $false)]
        [string] $mnodeSize,
        [parameter()]
        [ValidateSet(2,3,4,5,6,7,8)]
        [int] $minCnodes = 2,
        [parameter()]
        [switch] $readCacheEnabled,
        [parameter()]
        [switch] $whatif,
        [parameter()]
        [switch] $wait,
        [parameter()]
        [switch] $iscsiOnMgmt,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )


    $flexCluster = Get-FLEXCluster -flexContext $flexContext
    $flexParams = Get-FLEXClusterDefaults -flexContext $flexContext

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
    $finalBody | Add-Member -MemberType NoteProperty -Name "security_password" -Value $flexParams.security_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "security_password_confirm" -Value $flexParams.security_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "viewer_password" -Value $flexParams.viewer_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "viewer_password_confirm" -Value $flexParams.viewer_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "replication_password" -Value $flexParams.replication_password
    $finalBody | Add-Member -MemberType NoteProperty -Name "replication_password_confirm" -Value $flexParams.replication_password
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

    $finalBody | Add-Member -MemberType NoteProperty -Name "enabled_checkpointing" -Value $true

    $cnodeBody = New-Object psobject
    if ($readCacheEnabled) {
        $cnodeBody | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "production_rcs"
    } else {
        $cnodeBody | Add-Member -MemberType NoteProperty -Name "cloud_node_type" -Value "production_ilc"
    }
    
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