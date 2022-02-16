function Get-FLEXClusterSDP {
    param(
        [parameter()]
        [string] $name,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $flexTopology = Get-FLEXTopology -flexContext $flexContext
    $results = ($flexTopology | Where-Object {$_._type -eq "k2ns"})._obj
    if ($name) {
        $results = $results | where-object {$_.name -eq $name}
    }
    return $results
}