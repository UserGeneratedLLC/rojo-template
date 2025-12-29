#Requires -Version 5.1

$ProjectRbxl = "Project.rbxl"
$ProjectJsonFile = "default.project.json"

# Load .env file
Get-Content ".env" | ForEach-Object {
  if ($_ -match "^\s*([^#][^=]+)=(.*)$") {
    Set-Variable -Name $Matches[1].Trim() -Value $Matches[2].Trim() -Scope Script
  }
}

$ProjectJson = Get-Content $ProjectJsonFile | ConvertFrom-Json
$PlaceId = $ProjectJson.servePlaceIds[0]
Write-Host "PlaceId: $PlaceId"

# Download rbxl from Roblox
$Url = "https://assetdelivery.roblox.com/v1/asset/?id=$PlaceId"
Write-Host "Downloading $Url..."
$ProgressPreference = 'SilentlyContinue'
$client = New-Object System.Net.WebClient
$client.Headers.Add('Cookie', ".ROBLOSECURITY=$ROBLOSECURITY")
$client.DownloadFile($Url, $ProjectRbxl)

if ($args.Count -eq 0) {
  rojo syncback --non-interactive --input $ProjectRbxl $ProjectJsonFile
} else {
  rojo syncback @args --input $ProjectRbxl $ProjectJsonFile
}
