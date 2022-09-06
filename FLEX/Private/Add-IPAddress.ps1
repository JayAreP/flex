function Add-IPAddress {    
    param(
        [Parameter(Mandatory)]
        [ipaddress] $source,
        [Parameter(Mandatory)]
        [ipaddress] $delta
    )

    [ipaddress] $sum = $source.Address + $delta.Address

    return $sum
}