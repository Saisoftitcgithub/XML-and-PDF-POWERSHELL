# Login API endpoint
$url = "http://192.168.0.150:80/seeddms/restapi/index.php/login"

# Form data to send with POST request
$formData = @{
    user = "admin"
    pass = "admin"
}

# Send POST request and get response headers
$responseHeaders = Invoke-WebRequest -Uri $url -Method Post -ContentType "application/x-www-form-urlencoded" -Body $formData -SessionVariable session | Select-Object -ExpandProperty Headers

# Get the value of the "Set-Cookie" header
$cookie = $responseHeaders["Set-Cookie"]

# Output the cookie value to the console
Write-Output "Cookie: $cookie"

# Example usage: send GET request to folder endpoint to retrieve folder ID
$url = "http://192.168.0.150:80/seeddms/restapi/index.php/folder/FLPR-17-001"

# Send GET request with the cookie
$response = Invoke-WebRequest -Uri $url -Method Get -WebSession $session -Headers @{ Cookie = $cookie }

# Parse the JSON response to get the folder ID
$folderId = ($response.Content | ConvertFrom-Json).data.id

Write-Output "Folder ID: $folderId"

$filesPath = "C:\MH\TAX INVOICE\output\Apifile"
$executionPath = "$filesPath\Execution"

if (!(Test-Path $executionPath)) {
    New-Item -ItemType Directory -Path $executionPath | Out-Null
}

# Get all the files in the folder
$files = Get-ChildItem -Path $filesPath -File

foreach ($file in $files) {
    # Get the file name and full path
    $fileName = $file.Name
    $fileFullPath = $file.FullName

    # Start a new PowerShell process for each file
    Start-Process -FilePath PowerShell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSScriptRoot\Apifileinv.ps1`" `"$fileName`" `"$fileFullPath`" `"$folderId`"
}
