# FlexEchoDB

Flex Echo Database management functions. 


## Get-FlexEchoDB
```PowerShell
Get-FLexEchoDB [[-name] <string>] [[-id] <string>] [[-host_id] <string>] [[-flexContext] <string>] [-showFiles] [<CommonParameters>]
```

#### Parameters

Optional

* `-hostID` - [string] - text req = false
* `-id` - [string] - text req = false
* `-name` - [string] - text req = false
* `-showFiles` - [switch] - text req = false


Examples:

Get information on a database registered on `hostID` `echo01` with the `id` of `7`:
```PowerShell
Get-FLexEchoDB -id 7 -hostID echo01
```

Get file information for this same echo database:
```PowerShell
Get-FLexEchoDB -id 7 -hostID echo01 -showFiles
```