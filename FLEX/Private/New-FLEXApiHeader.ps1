function New-FLEXAPIHeader {
    param(
        [parameter(mandatory)]
        [string] $token,
        [parameter()]
        [switch] $post
    )

    $result = @{"Authorization" = "Bearer "+ $token}

    if ($post) {
        $result.Add('Content-Type','application/json')
    }

    return $result
}