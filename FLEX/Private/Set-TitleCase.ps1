function Set-TitleCase {
    param(
        [parameter(Mandatory)]
        [string] $string,
        [parameter()]
        [switch] $toCaps
    )

    if ($toCaps) {
        $results = $string.ToUpper()
    } else {
        $TextInfo = (Get-Culture).TextInfo
        $results = $TextInfo.ToTitleCase($string.ToLower())
    }
    return $results
}