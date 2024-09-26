# ps-hass

So I wanted to put icons on my desktop to switch things in my Home Assistant
smart home system. eg: the Laptop wanted to toggle its charger on and off and
the desktop wanted to power up the 3D printer.

Now HA offers a REST API so the obvious tool was Powershell.

For that you need a token so HA knows you're the right person which is a HA
function and the HA URL.

I wrote a script hass.ps1 that contains the working functions which are:

**Set-Hass** -domain $domain -object $object -action $action  
set the state of an object  
$domain is the type eg: switch  
$object is the item eg: switch.lamp1  
$action is what to do eg: turn_on turn_off toggle  
returns nothing

**Get-Hass** -object $object  
get the state of an object  
$object is the item eg: switch.lamp1  
returns a hash table made from the HA return json file  
eg: $result.state is probably 'on' or 'off'

I also wanted the icon to reflect the state of the switch so I wrote a tool to
do that:

**Set-ShortcutIcon** -target $target -icon $icon  
replace the icon image  
$target the item on the desktop  
$icon the icon file  

For example the 'target' of my 3D printer shortcut on its properties page is:  
(please excuse the line breaks which are needed to get it on screen here)  
&nbsp;&nbsp;&nbsp;&nbsp;C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe   
&nbsp;&nbsp;&nbsp;&nbsp;D:\Util\hass.ps1  
&nbsp;&nbsp;&nbsp;&nbsp;-domain switch  
&nbsp;&nbsp;&nbsp;&nbsp;-action toggle  
&nbsp;&nbsp;&nbsp;&nbsp;-object switch.smart_plug_mini_switch  
&nbsp;&nbsp;&nbsp;&nbsp;-link 3DPrinter.lnk  
&nbsp;&nbsp;&nbsp;&nbsp;-officon "D:\Util\power-red-64.ico"  
&nbsp;&nbsp;&nbsp;&nbsp;-onicon "D:\Util\power-green-64.ico"

However that doesn't keep up with 'off line' changes so I decided I needed a
script that run at startup (or return from hibernate) to do stuff so I called
it AutoExec.ps1 and put it on the D: drive because Windows makes such a song
and dance about touching C:\  

AutoExec.xml is an example to import into the Task Scheduler Library but don't
forget to edit in your own username/ID and when it saves you provide the
appropriate username/password so it can execute. 

My D:/AutoExec.ps1 contains the line  
&nbsp;&nbsp;&nbsp;&nbsp;C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe  
&nbsp;&nbsp;&nbsp;&nbsp;D:\Util\hass.ps1  
&nbsp;&nbsp;&nbsp;&nbsp;-domain switch  
&nbsp;&nbsp;&nbsp;&nbsp;-object switch.smart_plug_mini_switch    
&nbsp;&nbsp;&nbsp;&nbsp;-link 3DPrinter.lnk  
&nbsp;&nbsp;&nbsp;&nbsp;-officon "D:\Util\power-red-64.ico"   
&nbsp;&nbsp;&nbsp;&nbsp;-onicon "D:\Util\power-green-64.ico"


I hope that this is readable. I really hate MarkDown. Anything that uses white
space syntactically is manifestly evil.