Function Canary {

    [CmdletBinding()]

    Param (
        [string] $EndPoint,
        [int] $Port
    )

    Process {

        $userDomain = $env:userdomain + "\" + $env:username
        $externalIp = (Invoke-WebRequest -uri "http://ifconfig.me/ip" -UseBasicParsing).Content

        $Message = '[{0}] {1} Connected.' -f $externalIp, $userDomain

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
