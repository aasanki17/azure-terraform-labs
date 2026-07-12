# Install IIS Web Server and management tools
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Start the IIS service
Start-Service W3SVC

# Create a custom default webpage
Set-Content -Path "C:\inetpub\wwwroot\index.html" -Value "This is the server $($env:COMPUTERNAME)!"