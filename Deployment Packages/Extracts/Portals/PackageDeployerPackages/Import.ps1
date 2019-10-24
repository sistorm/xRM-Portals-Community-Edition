param
(
	$organizationName,

	$serverUrl,

	$lcid,

	$timeout = "02:00:00"
)

function Get-ScriptDirectory
{
	if ($script:MyInvocation.MyCommand.Path) { Split-Path $script:MyInvocation.MyCommand.Path } else { $pwd }
}

function Choose-ConnectionType
{
	[CmdletBinding()]
	param (
		$caption = "CRM Connection Type",
		$message = "Select a CRM connection type:"
	)

	process {
		$choices = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]
		$choices.Add((New-Object System.Management.Automation.Host.ChoiceDescription "On-&Premise", "On-Premise"))
		$choices.Add((New-Object System.Management.Automation.Host.ChoiceDescription "&Office 365", "Office 365"))
		$choice = $host.ui.PromptForChoice($caption, $message, $choices, 0)
		
		return $choice
	}
}

function Get-ServerUrl
{
	return Read-Host -Prompt "Specify Server URL: "
}

function Get-OrganizationName
{
	return Read-Host -Prompt "Specify Organization Name: "
}

function Get-LCID
{
	return Read-Host -Prompt "Specify Language Locale ID (LCID) [If left blank, default 1033 (English) will be used]: "
}

function Choose-Package
{
	[CmdletBinding()]
	param (
		[parameter(position=0, mandatory=$true)]
		$packages,
		$caption = "Package Import",
		$message = "Select a package to import:"
	)

	process {
		$choices = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]
		$packages | % { $choices.Add((New-Object System.Management.Automation.Host.ChoiceDescription "&$($_.Index)) $($_.Name)", $_.Name)) }
		$choice = $host.ui.PromptForChoice($caption, $message, $choices, 0)
		$package = $packages[$choice]

		return $package
	}
}

$scriptDir = Get-ScriptDirectory

if ($serverUrl -eq $null) {
	$connection = Choose-ConnectionType
	if ($connection -eq 0) {
		$serverUrl = Get-ServerUrl
	}
}

if ($organizationName -eq $null) {
	$organizationName = Get-OrganizationName
}

if ($lcid -eq $null) {
	$lcid = Get-LCID
	if ($lcid -eq $null){
		$lcid = "1033"
	}
}

$packages = (
	@{ Index = 0; Name = "Starter Portal"; Directory = "StarterPortal"; Assembly = "Adxstudio.StarterPortal.dll" },
	@{ Index = 1; Name = "Community Portal"; Directory = "CommunityPortal"; Assembly = "Adxstudio.CommunityPortal.dll" },
	@{ Index = 2; Name = "Customer Portal"; Directory = "CustomerPortal"; Assembly = "Adxstudio.CustomerPortal.dll" },
	@{ Index = 3; Name = "ESS Portal"; Directory = "ESSPortal"; Assembly = "Adxstudio.ESSPortal.dll" },
	@{ Index = 4; Name = "Partner Portal"; Directory = "PartnerPortal"; Assembly = "Adxstudio.PartnerPortal.dll" },
	@{ Index = 5; Name = "Partner Field Service"; Directory = "PartnerFieldService"; Assembly = "Adxstudio.PartnerFieldService.dll" },
	@{ Index = 6; Name = "Partner Project Service"; Directory = "PartnerProjectService"; Assembly = "Adxstudio.PartnerProjectService.dll" }
)

$package = Choose-Package $packages

if ($package -ne $null)
{
	$packageDirectory = Join-Path $scriptDir $package.Directory -Resolve
	& "$scriptDir\ImportPackage.ps1" -packageDirectory $packageDirectory -packageName $package.Assembly -organizationName $organizationName -serverUrl $serverUrl -lcid $lcid -timeout $timeout
}

Read-Host -Prompt "Press Enter to exit"
