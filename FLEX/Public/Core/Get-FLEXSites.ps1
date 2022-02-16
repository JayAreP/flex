function Get-FLEXSites {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $results = Get-FLEXTopology -flexContext $flexContext
    $results = ($results | Where-Object {$_._type -eq 'sites'})._obj
    return $results
}