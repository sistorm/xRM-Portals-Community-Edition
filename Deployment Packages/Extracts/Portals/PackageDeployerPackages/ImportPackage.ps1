param
(
    [parameter(mandatory=$true)]
    $packageDirectory,

    [parameter(mandatory=$true)]
    $packageName,

    [parameter(mandatory=$true)]
    $organizationName,

    $serverUrl,

    $lcid = 1033,

    $bypassData = $false,

    $timeout = "02:00:00"
)

Add-PSSnapin Microsoft.Xrm.Tooling.Connector
Add-PSSnapin Microsoft.Xrm.Tooling.PackageDeployment

$cred = Get-Credential

if ($serverUrl) {
    $CRMConn = Get-CrmConnection -ServerUrl $serverUrl -OrganizationName $organizationName -Credential $cred -LogWriteDirectory C:\DebugTrace -Verbose -MaxCrmConnectionTimeOutMinutes 120
} else {
    $CRMConn = Get-CrmConnection –OnlineType Office365 –OrganizationName $organizationName -Credential $cred -LogWriteDirectory C:\DebugTrace -Verbose -MaxCrmConnectionTimeOutMinutes 120
}

$CRMConn

Import-CrmPackage –CrmConnection $CRMConn –PackageDirectory $packageDirectory –PackageName $packageName -Verbose -Timeout $timeout -RuntimePackageSettings "LCID=$lcid|DataImportBypass=$bypassData" -LogWriteDirectory C:\DebugTrace 

