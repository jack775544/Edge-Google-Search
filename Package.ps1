<#
.DESCRIPTION
Package or unpackage the extension

.PARAMETER Operation
The packageing operation to do. The valid options are 'pack' and 'unpack'

.EXAMPLE
Package-App pack

.NOTES
This function is used specifically for the Reverse Search for Microsoft Edge extension
#>
function Package-App {
    param(
        [Parameter(Position=1, Mandatory=$true)]
        [ValidateSet('pack', 'unpack')]
        [string]
        $Operation
    )

    if ($Operation -eq 'deploy') {
        & "C:\Program Files (x86)\Windows Kits\10\bin\x64\makeappx.exe" pack /h SHA256 /d .\app\ /p "edge-search"
    } elseif ($Operation -eq 'unpack') {
        & "C:\Program Files (x86)\Windows Kits\10\bin\x64\makeappx.exe" unpack /v /p "edge-search.appx" /d "extract"
    }    
}

Package @args