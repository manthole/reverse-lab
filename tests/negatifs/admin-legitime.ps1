# Script d'administration ordinaire : il ne doit déclencher aucune règle.
$processus = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
$rapport = $processus | ConvertTo-Json
$octets = [Text.Encoding]::UTF8.GetBytes($rapport)
$archive = [Convert]::ToBase64String($octets)
Set-Content -Path .\rapport.txt -Value $archive
