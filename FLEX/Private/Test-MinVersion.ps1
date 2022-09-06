function Test-MinVersion {
    [string]$threshold = "1.4.28"

    # [int]$majorThreshold = $threshold.Split('.')[0]
    [int]$minorThreshold = $threshold.Split('.')[1]
    # [int]$subThreshold = $threshold.Split('.')[2]

    $version = Get-FLEXVersion
    $currentVersion =  $version.Replace('v',$null)

    # [int]$majorCurrent = $currentVersion.Split('.')[0]
    [int]$minorCurrent = $currentVersion.Split('.')[1]
    # [int]$subCurrent = $currentVersion.Split('.')[2]

    if ($minorCurrent -lt $minorThreshold) {
        $versionError = "This version of flex - " + $version + " - is lower than the supported version - " + $threshold + " - for this module. Please use an earlier build of the Flex SDK for this instance of Flex"
        return $versionError 
    }
}