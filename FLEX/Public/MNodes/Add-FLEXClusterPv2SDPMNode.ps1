function Add-FLEXClusterPv2SDPMNode {
    param(
        [parameter(Mandatory)]
        [string] $sdpName,
        [parameter(Mandatory)]
        [ValidateSet('P5', 'P10', 'P20', 'P40', 'P80', IgnoreCase = $false)]
        [string] $mnodeSize,
        [parameter()]
        [switch] $wait,
        [parameter()]
        [switch] $whatif,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        # get current 40k/80k MNode SKU

        $mnodeData = Select-FLEXMnodeSize -mnodeSize $mnodeSize 

        $flexCluster = Get-FLEXCluster -flexContext $flexContext
        
        if (!$flexCluster.id) {
            $err = "No cluster discovered, please first connect to FLEX using Connect-FLEX"
            $err | Write-Error
            exit
        }
        
        $flexSDP = Get-FLEXClusterSDP -name $sdpName -flexContext $flexContext
        if (!$flexSDP.id) {
            $err = "No SDP discovered, pleae check the value for sdpName"
            $err | Write-Error
            exit
        }
        $endpoint = 'clusters/' + $flexCluster.id + '/sdps/' + $flexSDP.id + '/add_nodes'
        $api = 'v2'
    }
    
    process {
        # MNode object
        $mnodeObject = New-Object psobject
        $mnodeObject | Add-Member -MemberType NoteProperty -Name 'cloud_node_type' -Value $mnodeData.mnodeSKU
        $mnodeObject | Add-Member -MemberType NoteProperty -Name 'amount' -Value 1

        # Body building 
        $finalBody = New-Object psobject
        $finalBody | Add-Member -MemberType NoteProperty -Name 'mnodes' -Value @($mnodeObject)
        $finalBody | Add-Member -MemberType NoteProperty -Name 'cnodes_quantity' -Value 0

        # Submit the call 
        if ($whatif) {
            $endpoint | Write-Host -ForegroundColor yellow
            $finalBody | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor yellow
        } else {
            $results = Invoke-FLEXRestCall -method POST -API $api -endpoint $endpoint -body $finalBody -flexContext $flexContext
            if ($wait) {
                Write-FLEXProgress -message "Adding MNode"
            }
            return $results._obj
        }
    }
}