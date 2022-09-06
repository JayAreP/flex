function Start-FLEXPreflight {
    param(
        [parameter()]
        [string] $flexContext = 'FLEXConnect',
        [parameter()]
        [string] $flexValidVersion = 'flex-2021-08-15-06.13.44'
    )

    $globalcheck = Get-Variable -Scope Global -Name $flexContext
    if (!$globalcheck) {
        $err = "Please first connect to FLEX environment using Connect-FLEX"
        return $err | Write-Error
    }

    $flexVersion = Get-FLEXVersion
    [int64] $flexVersionInt = $flexVersion.Replace('flex-',$null).replace('-',$null).replace('.',$null)
    [int64] $flexValidIntInt = $flexValidVersion.Replace('flex-',$null).replace('-',$null).replace('.',$null)
    if ($flexValidIntInt -lt $flexVersionInt) {
        $err = "Curent supported version is $flexValidVersion but cluster is running $flexVersion"
        return $err | Write-Error
    }

}