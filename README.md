# Silk Flex PowerShell SDK 
### Currently I consider this SDK very experimental, and do not recommend use in production deployments without thoroughly testing. The purpose of this module is mostly to demonstrate the API functionality of the FLEX platform, and actually contains very few actionable functions.
----
### Installation 
For now, clone this repo and import the module manually via:
```powershell
Import-Module ./path/FLEX/flex.psm1
```

Or, run the provided InstallFLEX.ps1 script. 
```powershell
Unblock-File .\InstallFLEX.ps1
.\InstallFLEX.ps1
```
Which gives you a simple install menu. 
```powershell
------
1. C:\Users\user\Documents\PowerShell\Modules
2. C:\Program Files\PowerShell\Modules
3. c:\program files\powershell\7\Modules
4. C:\Program Files (x86)\WindowsPowerShell\Modules
5. C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
------
Select Install location:
```

### Example usage: 

This module requires Powershell 4.x or above and was developed on PowerShell Core Preview 7. 
After importing, you can connect to the Silk Flex Platform using a conventional PowerShell credential object to acquire an auth token. 
```powershell
$creds = get-credential
Connect-FLEX -server 54.102.19.180 -credentials $creds
```

Which will return an auth token for use, and store endpoint information into a global variable space. 

```powershell
access_token                                expiresIn expiresOn
------------                                --------- ---------
QqBK6OWSDwYtT00RgL7sF3q1tMy3ODiChts5Husti1j   1209600 2020-10-20 00:19:35
```

You can then use the functions in the module manifest to perform the desired operations. 
```Powershell
# Gather all flex tasks:
Get-FLEXTask

# Show the FLEX networking configuration:
Get-FLEXClusterNetwork

# Create a c-node for an existing cluster:
Get-FLEXCluster | Add-FLEXClusterCloudCNode 

# Show all available nodes (those in the free pool)
Get-FLEXClusterCNodes -showAvailable 

# Move all FLEX Cluster c-node from the free pool to a registered SDP:
Get-FLEXClusterCNodes -showAvailable | Move-FLEXClusterCNode -targetName "My SDP"

# Invoke a wait on some operations (for better inherit sequencing). For example, this sequence will wait on the c-node to be created prior to the move operation:
Get-FLEXCluster | Add-FLEXClusterCloudCNode -wait
Get-FLEXClusterCNodes -showAvailable | Move-FLEXClusterCNode -targetName "My SDP"

# Delete all of the nodes in the free pool
Get-FLEXClusterCNodes -showAvailable | Remove-FLEXClusterCloudCNode

# Use the bespoke REST handler for quick REST call modeling:
Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/nodes'
```

### Verbosity:  

Specify -Verbose on any cmdlet to see the entire API process, including endoint declarations, and json statements. You can use this to help model API calls directly or troubleshoot. 

```powershell
Get-FLEXClusterCNodes -showAvailable | Remove-FLEXClusterCloudCNode -Verbose
```

Will return yellow verbose messages showing the entire API call and payload:
```
VERBOSE: {
  "Authorization": "Bearer  3q1tMyhtsi1jiC6sFOWSQqBKT00Rg3OD5HustDwYtL6"
}
VERBOSE: {
  "node_type": "cnode",
  "node_id": "flex-cluster-1001-cnode-4",
  "cluster_id": "1001"
}
VERBOSE: POST https://54.102.19.180/api/v1/tasks/remove_from_freepool with 96-byte payload
VERBOSE: received 1142-byte response of content type application/json
VERBOSE: Content encoding: utf-8

VERBOSE: {
  "Authorization": "Bearer  3q1tMyhtsi1jiC6sFOWSQqBKT00Rg3OD5HustDwYtL6"
}
VERBOSE: {
  "node_type": "cnode",
  "node_id": "flex-cluster-1001-cnode-8",
  "cluster_id": "1001"
}
VERBOSE: POST https://54.102.19.180/api/v1/tasks/remove_from_freepool with 96-byte payload
VERBOSE: received 1142-byte response of content type application/json
VERBOSE: Content encoding: utf-8
VERBOSE: {
  "Authorization": "Bearer  3q1tMyhtsi1jiC6sFOWSQqBKT00Rg3OD5HustDwYtL6"
}
VERBOSE: {
  "node_type": "cnode",
  "node_id": "flex-cluster-1001-cnode-9",
  "cluster_id": "1001"
}
VERBOSE: POST https://54.102.19.180/api/v1/tasks/remove_from_freepool with 96-byte payload
VERBOSE: received 1142-byte response of content type application/json
VERBOSE: Content encoding: utf-8
```

And then return the stardard response:
```
_id                    _version _obj
---                    -------- ----
3WWiAfNDkbqq9CmFgZIbRX        1 @{plot=; state=pending; progress_pct=0; creator_id=kaminario; update_ts_millis=1601996377310; create_ts_millis=1601996377310; steps=System.Object[]; labels=; type=remove-node-…
2sEHYj1ooPBO9UUGk0pz0L        1 @{plot=; state=pending; progress_pct=0; creator_id=kaminario; update_ts_millis=1601996377584; create_ts_millis=1601996377584; steps=System.Object[]; labels=; type=remove-node-…
1jxQowXYtgN30iQhc9tGEx        1 @{plot=; state=pending; progress_pct=0; creator_id=kaminario; update_ts_millis=1601996377862; create_ts_millis=1601996377862; steps=System.Object[]; labels=; type=remove-node-…
```

```
