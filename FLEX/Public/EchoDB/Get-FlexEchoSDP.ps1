function Get-FlexEchoSDP {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $results = (Get-FLEXEchoTopology -flexContext $flexContext).sdps

    return $results

}