<#
.DESCRIPTION
Package or unpackage the extension

.PARAMETER Operation
The packageing operation to do. The valid options are 'pack', 'unpack' and 'cert'

.EXAMPLE
Package.ps1 pack

.NOTES
This function is used specifically for the Reverse Search for Microsoft Edge extension.
This function will only run on Microsoft Windows 10
If running the cert option, it needs to be done as admin
#>
param(
    [Parameter(Position = 1, Mandatory = $true)]
    [ValidateSet('Pack', 'Unpack', 'Cert', 'Sign')]
    [string]
    $Operation
)

$ErrorActionPreference = "Stop"

switch ($Operation) {
    'Pack' {
        if ((Test-Path deploy) -eq $false) {
            New-Item -Type Directory deploy
        }
        & "C:\Program Files (x86)\Windows Kits\10\bin\x64\makeappx.exe" pack /h SHA256 /d .\app\ /p "deploy\edge-search"
        break
    }
    'Unpack' {
        & "C:\Program Files (x86)\Windows Kits\10\bin\x64\makeappx.exe" unpack /v /p "deploy\edge-search.appx" /d "extract"
        break
    }
    'Cert' {
        if ((Test-Path "deploy") -eq $false) {
            New-Item -Type Directory deploy
        }
        if ((Test-Path "deploy\cert") -eq $false) {
            New-Item -Type Directory "deploy\cert"
        }
        $Cert = New-SelfSignedCertificate -Type Custom -Subject "CN=21BCEA30-D080-426E-B3B0-03BFCF5A3F61" -KeyUsage DigitalSignature -FriendlyName "SearchCert" -CertStoreLocation "Cert:\LocalMachine\My"
        Write-Host $Cert
        $Thumbprint = $Cert.Thumbprint
        $Password = Read-Host -Prompt "Enter a password" -AsSecureString
        Export-PfxCertificate -cert "Cert:\LocalMachine\My\$Thumbprint" -FilePath deploy\cert\cert.pfx -Password $Password
        break
    }
    'Sign' {
        $Password = Read-Host -Prompt "Enter certificate password"
        SignTool sign /fd SHA256 /a /f .\deploy\cert\cert.pfx /p $Password .\deploy\edge-search.appx
    }
    Default {
        Write-Error "Invalid Option"
    }
}
