function Get-FlexEchoDB {
    param(
        [parameter()]
        [string] $name,
        [parameter()]
        [string] $id,
        [parameter(ValueFromPipelineByPropertyName)]
        [Alias("hostID")]
        [string] $host_id,
        [parameter()]
        [switch] $showFiles,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {
        # $hosts = Get-FLEXEchoHost
        # $topology = (Get-FLEXEchoTopology -flexContext $flexContext).databases | Where-Object {!$_.parent}
        $topology = (Get-FLEXEchoTopology -flexContext $flexContext) 
    }

    process {
        if ($host_id) {
            $results = ($topology | Where-Object {$_.host.id -eq $host_id}).databases
        } else {
            $results = $topology.databases
        }

        if ($name) {
            $results = $results | Where-Object {$_.name -eq $name}
        }

        if ($id) {
            $results = $results | Where-Object {$_.id -eq $id}
        }

        if ($showFiles) {
            $results = $results.files
        }

        return $results
    }



}