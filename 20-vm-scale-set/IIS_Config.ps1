# Install IIS Web Server and management tools
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Ensure IIS web root exists
New-Item -ItemType Directory -Force -Path "C:\inetpub\wwwroot"

# Create custom default webpages
Set-Content -Path "C:\inetpub\wwwroot\index.html" -Value "This is the server $($env:COMPUTERNAME)!"
Set-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value "This is the server $($env:COMPUTERNAME)!"

# Start and restart IIS
Start-Service W3SVC
iisreset