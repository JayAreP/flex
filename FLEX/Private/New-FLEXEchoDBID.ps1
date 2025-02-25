function New-FLEXEchoDBID {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    [int] $id = (Get-FLexEchoDB -flexContext $flexContext| Select-Object id | Sort-Object id).id[-1]
    $id++
    return $id
}
