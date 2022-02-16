function Convert-FLEXResults {
    param(
        [parameter(Mandatory)]
        [array] $resultsObject,
        [parameter()]
        [string] $object = '_obj',
        [parameter()]
        [switch] $hits,
        [parameter()]
        [switch] $includeID
    )

    begin {
        $resultArray = @()
        if ($hits) {
            $resultsObject = $resultsObject.hits
        }
    }

    process {
        foreach ($r in $resultsObject) {
            $o = New-Object psobject
            if ($includeID) {
                $o | Add-Member -MemberType NoteProperty -Name "taskid" -Value $r._id
            }
            $propArray = ($r.$object | Get-Member -MemberType NoteProperty).name
            foreach ($n in $propArray) {
                $o | Add-Member -MemberType NoteProperty -Name $n -Value $r.$object.$n
            }
            $resultArray += $o
        }

        return $resultArray
    }

}