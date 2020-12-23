$IndexJs = Get-ChildItem "$PSScriptRoot\index.*.bundle.js"
$JsFiles = Get-ChildItem "$PSScriptRoot\*.js"
$Maps = Get-ChildItem "$PSScriptRoot\*.map"
$Pngs = Get-ChildItem "$PSScriptRoot\*.png"

$Script:AssetId = [UniversalDashboard.Services.AssetService]::Instance.RegisterAsset($IndexJs.FullName)

foreach($item in $JsFiles)
{
    [UniversalDashboard.Services.AssetService]::Instance.RegisterAsset($item.FullName) | Out-Null
}

foreach($item in $Maps)
{
    [UniversalDashboard.Services.AssetService]::Instance.RegisterAsset($item.FullName) | Out-Null
}

$Pngs = Get-ChildItem "$PSScriptRoot\*.png"
foreach($item in $Pngs)
{
    [UniversalDashboard.Services.AssetService]::Instance.RegisterAsset($item.FullName) | Out-Null
}


function script:New-UDCalendar {
    param(
        [Parameter()]
        [string]$Id = (New-Guid).ToString(),

        [Parameter()]
        $Events,

        [Parameter()]
        [datetime]$DefaultDate = (get-date),

        [Parameter()]
        [int]$height = 500
    )

    End {
        @{
            assetId = $AssetId 
            isPlugin = $true 
            type = "ud-calendar"
            id = $Id

            events = $Events
            defaultDate = ($DefaultDate).tostring('yyyy-MM-dd HH:mm:ss')
            height = $height
        }
    }
}