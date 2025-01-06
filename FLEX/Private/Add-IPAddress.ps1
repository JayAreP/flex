function Add-IPAddress {    
    param(
        [Parameter(Mandatory)]
        [ipaddress] $source,
        [Parameter(Mandatory)]
        [ipaddress] $delta
    )

    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"

    [ipaddress] $sum = $source.Address + $delta.Address

    return $sum
}