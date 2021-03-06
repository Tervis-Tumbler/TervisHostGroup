﻿$HostGroupDefinition =  [PSCustomObject]@{
    Name = "Trevera"
    HostGroupName = "Oracle","ContractorSupportInfrastructure","OracleSupportInfrastructure"
},
[PSCustomObject]@{
    Name = "Fadel"
    HostGroupName = "Oracle","ContractorSupportInfrastructure","OracleSupportInfrastructure"
},
[PSCustomObject]@{
    Name = "eComchain"
    HostGroupName = "eComchainSupportInfrastructure"
},
[PSCustomObject]@{
    Name = "KerkeringBarberio"
    HostGroupName = "KerkeringBarberioSupportInfrastructure"
},
[PSCustomObject]@{
    Name = "Helios"
    HostGroupName = "MES","ContractorSupportInfrastructure","HeliosDeveloperDesktop"
},
[PSCustomObject]@{
    Name = "Oracle"
    HostGroupName = "OracleNonZeta","OracleZeta","OracleTransition"
},

[PSCustomObject]@{
    Name = "OracleNonZeta"
    DNSRecordType = "CNAME"
    Host = @"
apexweblogic
discoverer
ebsias
ebsodbee
infadac
obiaodbee
obieeweblogic
rpias
rpodbee
rpweblogic
soaodbee
soaweblogic
obiapp
"@ -split "`r`n"
    EnvironmentName = "Delta","Epsilon","Production"
},
[PSCustomObject]@{
    Name = "OracleZeta"
    DNSRecordType = "CNAME"
    Host = @"
ebsias
ebsodbee
rpias
rpodbee
rpweblogic
"@ -split "`r`n"
    EnvironmentName = "Zeta"
},
[PSCustomObject]@{
    Name = "OracleSupportInfrastructure"
    DNSRecordType = "CNAME"
    Host = @"
OraDBARMT
RemoteDesktopWebAccess
OracleEnterpriseManager
"@ -split "`r`n"
    EnvironmentName = "Infrastructure"
},
[PSCustomObject]@{
    Name = "ContractorSupportInfrastructure"
    DNSRecordType = "A"
    Host = @"
rdbrocker2012r2
rdgateway2012r2
INF-RDWebAcc01
TFS2012
SharePoint2007
TrackIT
INF-DC01
INF-DC2
INF-DC3
passwordstate
P-OctopusDeploy
"@ -split "`r`n"
},
[PSCustomObject]@{
    Name = "MES"
    DNSRecordType = "CNAME"
    Host = @"
MESIIS
MESSQl
"@ -split "`r`n"
    EnvironmentName = "Delta","Epsilon","Production"
},
[PSCustomObject]@{
    Name = "HeliosDeveloperDesktop"
    DNSRecordType = "A"
    Host = @"
BOde-vm 
"@ -split "`r`n"
},
[PSCustomObject]@{
    Name = "OracleTransition"
    DNSRecordType = "A"
    Host = @"
DLT-ODBEE02
DLT-Weblogic02
"@ -split "`r`n"
},
[PSCustomObject]@{
    Name = "eComchainSupportInfrastructure"
    DNSRecordType = "A"
    Host = @"
INF-DC3
TFS2012
dlt-ias01
dlt-weblogic01
dlt-infadac
dlt-odbee01
DLT-OBIAPP
INF-PWState01
INF-DC01
INF-DC2
"@ -split "`r`n"
},
[PSCustomObject]@{
    Name = "KerkeringBarberioSupportInfrastructure"
    DNSRecordType = "A"
    Host = @"
INF-DC3
INF-DC01
INF-DC2
ebsapps-prd
SharePoint2007
p-weblogic01
"@ -split "`r`n"
}

