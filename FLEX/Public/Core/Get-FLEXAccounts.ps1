function Get-FLEXAccounts {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"

    $results = Get-FLEXTopology -flexContext $flexContext
    $results = ($results | Where-Object {$_._type -eq 'accounts'})._obj
    return $results
}