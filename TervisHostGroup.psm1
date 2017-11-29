$ModulePath = (Get-Module -ListAvailable TervisHostGroup).ModuleBase
. $ModulePath\Definition.ps1

function Get-HostGroupHostDNSName {
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]$HostGroupName
    )
    process {
        $HostGroup = $HostGroupDefinition | 
        Where-Object Name -EQ $HostGroupName

        if ($HostGroup.HostGroupName) {
            $HostGroup.HostGroupName | Get-HostGroupHostDNSName
        }

        if ($HostGroup.EnvironmentName) {
            foreach ($EnvironmentName in $HostGroup.EnvironmentName) {
                $HostGroup.Host | Get-TervisDNSName -EnvironmentName $EnvironmentName                
            }
        } elseif ($HostGroup.Host) {
            $HostGroup.Host | Get-TervisDNSName
        }
    }
}

function Get-HostGroupHostIPAddress {
    Param (
        [Parameter(Mandatory)]$HostGroupName
    )
    $DNSNames = Get-HostGroupHostDNSName -HostGroupName $HostGroupName

    $DNSRecords = foreach ($DNSName in $DNSNames) {
        Resolve-DnsName -Name $DNSName |
        Where-Object QueryType -EQ "A" 
    }

    $Sorted = $DNSRecords |
    % {[Version]$_.IPAddress } |
    Sort -Unique 
    
    $Sorted | % { $_.ToString() }
}

function Test-OracleCNAME {
    $OracleCNAMEs = Get-OracleCNAME
    foreach ($CNAME in $OralceCNAMEs) {
        Resolve-DnsName -Name $CNAME -Type CNAME
    }
}

function Get-HostGroupCNAMEToDNSAMapping {
    Param (
        [Parameter(Mandatory)]$HostGroupName
    )
    $DNSNames = Get-HostGroupHostDNSName -HostGroupName $HostGroupName

    $DNSNames |
    % { Resolve-DnsName -Name $_ -Type CNAME } |
    Select-Object -Property Name, NameHost
}

function Get-HostGroupHost {
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]$HostGroupName
    )
    process {
        $HostGroup = $HostGroupDefinition | 
        Where-Object Name -EQ $HostGroupName

        if ($HostGroup.HostGroupName) {
            $HostGroup.HostGroupName | Get-HostGroupHost
        }
        
        if ($HostGroup.EnvironmentName) {
            foreach ($EnvironmentName in $HostGroup.EnvironmentName) {
                $HostGroup.Host | Get-TervisHost -EnvironmentName $EnvironmentName -DNSRecordType $HostGroup.DNSRecordType
            }
        } elseif ($HostGroup.Host) {
            $HostGroup.Host | Get-TervisHost -DNSRecordType $HostGroup.DNSRecordType
        }
    }
}

function Get-TervisHost {
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]$HostName,
        $EnvironmentName,
        $DNSRecordType
    )
    process {
        [PSCustomObject][Ordered]@{
            HostName = $HostName
            EnvironmentName = $EnvironmentName
            DNSRecordType = $DNSRecordType
        }
    }
}

function Get-TervisHostGroupCNAMEAndA {
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]$HostGroupName
    )
    process {
        $Hosts = Get-HostGroupHost -HostGroupName $HostGroupName

        $CNAMEHosts = $Hosts |
        Where-Object DNSRecordType -EQ CNAME 

        $DNSHosts = ForEach ($CNAMEHost in $CNAMEHosts) {
            $CNAME = $CNAMEHost.HostName | Get-TervisDNSName -EnvironmentName $CNAMEHost.EnvironmentName

            $DNSAName = Resolve-DnsName -Name $CNAME |
            Where-Object QueryType -EQ "A" |
            Select-Object -ExpandProperty Name

            $DNSAName | Get-TervisHost -EnvironmentName $CNAMEHost.EnvironmentName -DNSRecordType "A"
            $CNAME | Get-TervisHost -EnvironmentName $CNAMEHost.EnvironmentName -DNSRecordType "CNAME"
        }

        $DNSHosts |
        Sort-Object -Unique -Property HostName,EnvironmentName,DNSRecordType
    }
}
