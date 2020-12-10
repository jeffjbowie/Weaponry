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
