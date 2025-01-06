function New-FLEXClassObject {
    param(
        [parameter(Mandatory)]
        [string] $inputArray,
        [parameter(Mandatory)]
        [string] $class
    )
    $functionName = $MyInvocation.MyCommand.Name
    Write-Verbose "-> $functionName"

}