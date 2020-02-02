$BuildFolder = $PSScriptRoot

$powerShellGet = Import-Module PowerShellGet  -PassThru -ErrorAction Ignore
if ($powerShellGet.Version -lt ([Version]'1.6.0')) {
	Install-Module PowerShellGet -Scope CurrentUser -Force -AllowClobber
	Import-Module PowerShellGet -Force
}

Set-Location $BuildFolder

$OutputPath = "$BuildFolder\output\UniversalDashboard.Calendar"

Remove-Item -Path $OutputPath -Force -ErrorAction SilentlyContinue -Recurse
Remove-Item -Path "$BuildFolder\public" -Force -ErrorAction SilentlyContinue -Recurse

& npm install
& npm run build

New-Item -Path $OutputPath -ItemType Directory

Copy-Item $BuildFolder\public\*.* $OutputPath
Copy-Item $BuildFolder\UniversalDashboard.Calendar.psm1 $OutputPath

$Version = "1.0.0"

$manifestParameters = @{
	Path = "$OutputPath\UniversalDashboard.Calendar.psd1"
	Author = "Adam Driscoll"
	CompanyName = "Ironman Software, LLC"
	Copyright = "2020 Ironman Software, LLC"
	RootModule = "UniversalDashboard.Calendar.psm1"
	Description = "Calendar for Universal Dashboard."
	ModuleVersion = $version
	Tags = @("universaldashboard", "calendar", 'ud-control')
	ReleaseNotes = "Initial release"
	FunctionsToExport = @(
		"New-UDCalendar"
	)
	RequiredModules = @()
	ProjectUri = "https://github.com/ironmansoftware/ud-calendar"
	IconUri = 'https://raw.githubusercontent.com/ironmansoftware/universal-dashboard/master/images/logo.png'
}

New-ModuleManifest @manifestParameters

if ($prerelease -ne $null) {
	Update-ModuleManifest -Path "$OutputPath\UniversalDashboard.Calendar.psd1" -Prerelease $prerelease
}