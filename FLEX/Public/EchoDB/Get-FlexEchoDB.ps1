function Get-FLexEchoDB {
    param(
        [parameter()]
        [string] $name,
        [parameter()]
        [string] $id,
        [parameter()]
        [switch] $showFiles,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    $results = (Get-FLEXEchoTopology -flexContext $flexContext).databases

    if ($name) {
        $results = $results | Where-Object {$_.name -eq $name}
    }

    if ($id) {
        $results = $results | Where-Object {$_.id -eq $id}
    }

    if ($showFiles) {
        $results = $results.files
    }

    return $results

}