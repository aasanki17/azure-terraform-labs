# Optional: Add sqlcmd to PATH if needed
$env:PATH += ";C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Bin"

# Download the SQL script securely from Blob Storage using SAS URL
Invoke-WebRequest -Uri "$env:BLOB_URL_WITH_SAS" -OutFile "load-data.sql"

# Execute SQL script using sqlcmd
sqlcmd -S "$env:SQL_SERVER.database.windows.net" `
       -d "$env:SQL_DB" `
       -U "$env:SQL_USERNAME" `
       -P "$env:SQL_PASSWORD" `
       -i "load-data.sql"