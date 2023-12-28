$token = $env:TARGETARCH 
if ($token -eq "amd64") {
    $token = "x64"
}
Get-ChildItem env:
write-host("Token is: " + $token)
start-sleep -Seconds 15
    
$result = (((Invoke-RestMethod  https://api.github.com/repos/Radarr/Radarr/releases?per_page=10) | Where-Object { $_.prerelease -eq $true })[0].tag_name).replace("v","")
write-host("Version number is: " + $result)
$URL = "https://github.com/Radarr/Radarr/releases/download/v$result/Radarr.develop.$result.linux-core-$token.tar.gz"
Write-Host("Going to try and download from :" + $URL) 
Start-Sleep -Seconds 5
try {
    invoke-webrequest  -uri $URL -UseBasicParsing -OutFile ./Radarr.Binaries.tar.gz
}
catch {
    Write-Error $_.Exception.Message
    exit -1
}
