function Select-FLEXMnodeSize {
    param(
        [parameter(Mandatory)]
        [ValidateSet('P5', 'P10', 'P20', 'P40', 'P80', IgnoreCase = $false)]
        [string] $mnodeSize
    )

    $cloudType = $Global:FLEXConnect.cloud

    if ($cloudType -eq 'AZURE') {
        $Pv2Sizes = @('P5', 'P10', 'P20', 'P40', 'P80')
        $Pv2SizeArray = @{}
        $Pv2SizeArray.Add('P5','disks_5tib')
        $Pv2SizeArray.Add('P10','disks_10tib')
        $Pv2SizeArray.Add('P20','disks_20tib')
        $Pv2SizeArray.Add('P40','disks_40tib')
        $Pv2SizeArray.Add('P80','disks_80tib')
    
        $Pv2IOPSArray = @{}
        $Pv2IOPSArray.Add('40k','40000')
        $Pv2IOPSArray.Add('80k','80000')
    
        if ($Pv2Sizes -contains $mnodeSize) {   
            $mnodeSKU = $Pv2SizeArray[$mnodeSize]
        } 
    }

    return $mnodeSKU
}