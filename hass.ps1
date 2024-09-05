################################################################################
#
# automate a Home Assistant call
#
# use as
#   ./hass.ps1 -domain switch -action toggle -object switch.sonoff05
#
# or in a shortcut as
#   "C:\Program Files\PowerShell\7\pwsh.exe" D:\Util\hass.ps1 -domain switch `
#			 -action toggle -object switch.tas03 -link charger.lnk
#			-officon D:\Util\power-red-64.ico -onicon D:\Util\power-green-64.ico
#
# to update the icon
#   onit the -action value

# domain
#   switch etc.
#
# action
#   toggle | turn_on | turn_off  as appropriate
#
# object
#   entity id as switch.sonoff05
#
################################################################################

Param(
  [Parameter(Mandatory=$true)][string]$object,
  [Parameter()][string]$action=$null,
  [Parameter(Mandatory=$true)][string]$domain,
  [Parameter()][string]$link=$null,
  [Parameter(Mandatory=$true)][string]$officon,
  [Parameter(Mandatory=$true)][string]$onicon
)

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

# if there is an action perform the action
if($action -ne $null){
   Set-Hass -domain $domain -action $action -object $object
   Start-Sleep -Seconds 2
}

# if there is a link update the shortcut icon
if($link -ne $null){
   $x = Get-Hass -object $object
   if($x.state -match 'on'){ $icon = $onicon }
   else					{ $icon = $officon   }
   Set-ShortcutIcon -target $link  -icon $icon
}