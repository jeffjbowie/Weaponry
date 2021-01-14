# Weaponry

A collection of offensive code used for red team engagements. 

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
   
      * Write VBScript payload to %TEMP%/<random_name>.vbs, which checks an HTTP URL for Batch/PowerShell commands. 
   
      * Generates a list of Scheduled Tasks.
      
      * Identifies & duplicates the name of an existing Scheduled Task.
      
      * Creates a scheduled task with modified existing Task Name, executing %TEMP%/<random_name>.vbs every 10 minutes.
      
 ```

