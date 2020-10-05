function Get-FLEXSites {
    $results = Get-FLEXTopology
    $results = ($results | Where-Object {$_._type -eq 'sites'})._obj
    return $results
}