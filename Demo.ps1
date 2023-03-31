param (
    [string]$filename
)

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Write-Output "Execution policy set to RemoteSigned"

Write-Output "Filename: $filename"
