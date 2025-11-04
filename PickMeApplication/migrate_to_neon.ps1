# Migration Script - Export from Local PostgreSQL to Neon
# Chạy script này để export data từ PostgreSQL local

# 1. Export data từ local database
Write-Host "Exporting data from local PostgreSQL..."
pg_dump -h localhost -p 5433 -U myuser -d pickmeapplication -f backup_data.sql --data-only --inserts

# 2. Export schema (nếu cần)
Write-Host "Exporting schema from local PostgreSQL..."
pg_dump -h localhost -p 5433 -U myuser -d pickmeapplication -f backup_schema.sql --schema-only

Write-Host "Backup completed!"
Write-Host "Files created:"
Write-Host "- backup_data.sql (data only)"
Write-Host "- backup_schema.sql (schema only)"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Update your .env file with Neon database credentials"
Write-Host "2. Run the application to let Hibernate create tables automatically"
Write-Host "3. Import data using: psql -h your-neon-host -U your-neon-user -d your-neon-db -f backup_data.sql"