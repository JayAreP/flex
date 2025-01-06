function get-testfunction {

	param(
	$test
	)

	$functionName = $MyInvocation.MyCommand.Name
	Write-Verbose "-> $functionName" -verbose

}

