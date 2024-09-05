################################################################################
#
#  hass-lib.ps1			functions to control Home Assistant
#
################################################################################

Function Get-HassURL
{
	"http://192.168.1.201:8123"
}
Function Get-HassToken
{
    'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJkZWViMWI0MDk1ZDY0MDZjYTg0Yzg5ZjU4YjRmNmI2MSIsImlhdCI6MTcyMjE5NTIyNSwiZXhwIjoyMDM3NTU1MjI1fQ.aPcw8vgzhJuWdJRkYlXwcpdh4a369TZdxs3mZNZx5G8'
}

Function Set-Hass {
	Param(
        [Parameter(Mandatory=$true)][string]$object,
        [Parameter(Mandatory=$true)][string]$action,
        [Parameter(Mandatory=$true)][string]$domain
    )
    $hash    = @{ entity_id = "$object" }
    $json    = $hash | convertto-json
    $headers = @{ 'Authorization' = Get-HassToken }
    $url     = (Get-HassURL) + "/api/services/" + $domain + "/" + $action
    $res     = Invoke-WebRequest -uri $url -Headers $headers -Method POST -Body $json
}

Function Get-Hass {
	Param(
        [Parameter(Mandatory=$true)][string]$object
    )
    $headers = @{ 'Authorization' = Get-HassToken }
    $url = (Get-HassURL) + "/api/states/" + $object
    $res = Invoke-WebRequest -uri $url -Headers $headers -Method GET
    $res.Content | ConvertFrom-Json
}

Function Set-ShortcutIcon {
	Param (
		[Parameter(Mandatory=$true)][string]$target,
		[Parameter(Mandatory=$true)][string]$icon		# append ,2 for index
	)
	$DesktopPath = [Environment]::GetFolderPath("Desktop") + "\$target"
	$WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut($DesktopPath)
	$Shortcut.IconLocation = $icon
	$Shortcut.Save()
}


Set-Hass -domain "switch" -action "toggle" -object "switch.tasmota3"
Start-Sleep -Seconds 2
$x = Get-Hass -object "switch.tasmota3"
if($x.state -match 'on'){ $icon = "D:\Util\power-green-64.ico" }
else					{ $icon = "D:\Util\power-red-64.ico"   }
Set-ShortcutIcon -target "charger.lnk"  -icon $icon
