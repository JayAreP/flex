function New-FLEXAPIHeader {
    param(
        [parameter(mandatory)]
        [string] $token
    )


    $result = @{"Authorization" = "Bearer "+ $token}

    return $result
}