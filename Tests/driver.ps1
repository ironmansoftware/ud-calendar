param(
    [Switch]$NoClose,
    [Switch]$OutputTestResultXml,
    [string]$Control = 'calendar'
)

Import-Module Selenium
Import-Module UniversalDashboard
Import-Module (Join-Path $PSScriptRoot "../output/UniversalDashboard.Calendar/UniversalDashboard.Calendar.psd1") -Force 

$Tests = Get-ChildItem $PSScriptRoot -Filter "*.tests.ps1"

$Dashboard = New-UDDashboard -Title "Test" -Content {}
$Server = Start-UDDashboard -Port 10001 -Dashboard $Dashboard
$Driver = Start-SeFirefox
Enter-SeUrl -Url "http://localhost:10001" -Driver $Driver

function Set-TestData {
    param($Data)

    $StateCollection.Add($Data)
}

function Get-TestData {
    $Data = $null
    if ($Global:StateCollection.TryTake([ref]$Data, 5000)) {
        $Data 
    } 
    else {
        throw "Retreiving data timed out (5000ms)."
    }
}

function Set-TestDashboard {
    param(
        [ScriptBlock]$Content
    )

    $Global:StateCollection = New-Object -TypeName 'System.Collections.Concurrent.BlockingCollection[object]'

    $ScriptRoot = $PSScriptRoot
    $Dashboard = New-UDDashboard -Content $Content -Title "TEST" -EndpointInitialization (New-UDEndpointInitialization -Variable @("StateCollection", "ScriptRoot") -Function @("Set-TestData", "New-UDCalendar"))
    $Server.DashboardService.SetDashboard($Dashboard)
    Enter-SeUrl -Url "http://localhost:10001" -Driver $Driver
}


if ($OutputTestResultXml) {
    $OutputPath = "$PSScriptRoot\test-results" 
    Remove-Item $OutputPath -Recurse -ErrorAction SilentlyContinue -Force
    New-Item -Path $OutputPath -ItemType Directory

    Push-Location $PSScriptRoot
    Invoke-Pester -OutputFile (Join-Path $OutputPath "TEST-Materialize.xml") -OutputFormat NUnitXml
    Pop-Location
} else {
    $Tests | Where-Object { $_.Name.Contains($Control) } | ForEach-Object {
        . $_.FullName
    }
}

if (-not $NoClose) 
{
    Stop-UDDashboard -Port 10001
    Stop-SeDriver $Driver
}



