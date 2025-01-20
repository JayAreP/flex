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

This module requires Powershell 4.x or above and was developed on PowerShell Core 7. 
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

# Delete all of the nodes in the free pool
Get-FLEXClusterCNodes -showAvailable | Remove-FLEXClusterCloudCNode

# Create a new SDP using available cnodes and mnodes
New-FLEXClusterSDP -cnodes 2 -mnodeSize Small -name "My SDP 2"

# Use the bespoke REST handler for quick REST call modeling:
Invoke-FLEXRestCall -method GET -API v1 -endpoint 'pages/nodes'
```

### Verbosity:  

Specify `-Verbose` on any cmdlet to see the entire API process, including endoint declarations, and json API payloads. You can use this to help model API calls directly or troubleshoot. 
