# ps-hass

So I wanted to put icons on my desktop to switch things in my Home Assistant
smart home system. eg: the Laptop wanted to toggle its charger and the desktop
wanted to power up the 3D printer.

Now HA offers a REST API so the obvious tool was Powershell.

For that you need a token so HA knows you're the right person which is a HA
function (details later) and the HA URL.

I wrote a script hass.ps1 that contains the working functions

Set-Hass -domain $domain -object $object -action $action
set the state of an object
$domain is the type eg: switch
$object is the item eg: switch.lamp1
$action is what to do eg: turn_on turn_off toggle
returns nothing

Get-Hass -object $object
get the state of an object
$object is the item eg: switch.lamp1
returns a hash table made from the HA return json file
  eg $result.state is probably 'on' or 'off'

I also wanted the icon to reflect the state of the switch so I wrote a tool to
do that:

Set-ShortcutIcon -target $target -icon $icon
replace the icon image
$target the item on the desktop
$icon the icon file

For example the 'target of my 3D printer shortcut on its properties page is:
(please excuse the line breaks which are needed to get it on screen here)
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe 
     D:\Util\hass.ps1
     -domain switch -action toggle
     -object switch.smart_plug_mini_switch
     -link 3DPrinter.lnk
     -officon "D:\Util\power-red-64.ico"
     -onicon "D:\Util\power-green-64.ico"

