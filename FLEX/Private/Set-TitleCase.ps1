function Set-TitleCase {
    param(
        [parameter(Mandatory)]
        [string] $string,
        [parameter()]
        [switch] $toCaps
    )
    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"
    
    if ($toCaps) {
        $results = $string.ToUpper()
    } else {
        $TextInfo = (Get-Culture).TextInfo
        $results = $TextInfo.ToTitleCase($string.ToLower())
    }
    return $results
}