function New-FLEXAPIHeader {
    param(
        [parameter(mandatory)]
        [string] $token,
        [parameter()]
        [switch] $post
    )
    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"
    
    $result = @{"Authorization" = "Bearer "+ $token}

    if ($post) {
        $result.Add('Content-Type','application/json')
    }

    return $result
}