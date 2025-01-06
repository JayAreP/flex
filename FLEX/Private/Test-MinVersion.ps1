function Test-MinVersion {
    param(
        [parameter()]
        [string]$threshold = "1.80.34",
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )
    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"

    $globalVar = Get-Variable -Name $flexContext -Scope Global -ValueOnly

    if ($globalVar.SkipVersionCheck -eq $true) {
        $message = "Test-MinVersion --> Version checking disabled, skipping."
        return $message | Write-Verbose -Verbose
    }
    
    [int]$minorThreshold = $threshold.Split('.')[1]

    $version = Get-FLEXVersion
    $currentVersion =  $version.Replace('v',$null)

    [int]$minorCurrent = $currentVersion.Split('.')[1]

    if ($minorCurrent -lt $minorThreshold) {
        $versionError = "Test-MinVersion --> This version of flex - " + $version + " - is lower than the supported version - " + $threshold + " - for this module. Please use an earlier build of the Flex SDK for this instance of Flex"
        return $versionError | Write-Error
    }
}