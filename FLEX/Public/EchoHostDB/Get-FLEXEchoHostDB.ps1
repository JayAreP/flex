function Get-FLEXEchoHostDB {
    param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Alias('host_id')]
        [string] $hostID,
        [parameter()]
        [string] $flexContext = 'FLEXConnect'
    )

    begin {

    }

    process{
        $topology = Get-FLEXEchoTopology -flexContext $flexContext

        $databases = ($topology | Where-Object {$_.host.id -eq $hostID}).databases
    
        return $databases
    }

}