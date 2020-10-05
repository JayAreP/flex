function New-FLEXAPIHeader {
    param(
        [parameter(mandatory)]
        [string] $token,
        [parameter()]
        [switch] $secure
    )

    if ($secure) {
        $result = @{"Authorization" = "Bearer  "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($token))}
    } else {
        $result = @{"Authorization" = "Bearer  "+ $token}
    }
    return $result
}