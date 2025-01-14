function Convert-FLEXTimeStampFrom {
    param(
        [parameter(Mandatory)]
        [int64] $timestamp
    )
    $epoch = Get-Date -Date "01/01/1970" 
    $epochDate = $epoch.AddMilliseconds($timestamp)
    [datetime]$returnDate = get-date $epochDate -Format "dddd MM/dd/yyyy HH:mm:ss"
    return $returnDate
}
