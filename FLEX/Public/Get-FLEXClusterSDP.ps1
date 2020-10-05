function Get-FLEXClusterSDP {
    param(
        [parameter()]
        [string] $name
    )
    $flexTopology = Get-FLEXTopology
    $results = ($flexTopology | Where-Object {$_._type -eq "k2ns"})._obj
    if ($name) {
        $results = $results | where-object {$_.name -eq $name}
    }
    return $results
}