function Add-FLEXClusterCloudCNode {
    param(
        [parameter(Mandatory)]
        [string] $sdpName,
        [parameter()]
        [switch] $wait,
        [parameter()]
        [switch] $whatif,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {

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

        # Body building 
        $finalBody = New-Object psobject
        $finalBody | Add-Member -MemberType NoteProperty -Name 'mnodes' -Value @()
        $finalBody | Add-Member -MemberType NoteProperty -Name 'cnodes_quantity' -Value 1

        # Submit the call 
        if ($whatif) {
            $endpoint | Write-Host -ForegroundColor yellow
            $finalBody | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor yellow
        } else {
            $results = Invoke-FLEXRestCall -method POST -API $api -endpoint $endpoint -body $finalBody -flexContext $flexContext
            if ($wait) {
                Write-FLEXProgress -message "Adding CNode"
            }
            return $results._obj
        }
    }
}

