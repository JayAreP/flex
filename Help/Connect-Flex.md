# Connect-Flex

Function for connecting to a Flex deployment with this SDK. 

```PowerShell
Connect-FLEX [-credentials] <pscredential> [-server] <string> [[-flexContext] <string>] [-skipVersionChecks] [<CommonParameters>]
```

### Parameters

Mandatory
* `-server` - [string] - Management IP or name for the Flex console. 
* `-credentials` - [pscredential] - Credential used to authenticate to flex. 

Optional
* `-flexContext` - [string] - Allows you to set a specific context when connecting to flex. Useful when connecting to multiple instances of flex. 
* `-skipVersionChecks` - [switch] - Skip the built in version validation between this SDK and the target Flex deployment. 

Examples:

```PowerShell
$creds = Get-Credential
Connect-Flex -Server 10.30.51.11 -credentials $creds
```
