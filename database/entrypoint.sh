#!/bin/bash

set -e

echo "=========================================="
echo " Appointment Booking SQL Server"
echo "=========================================="

echo "Starting SQL Server..."

/opt/mssql/bin/sqlservr &

SQLSERVER_PID=$!

echo "Waiting for SQL Server to become ready..."

until /opt/mssql-tools18/bin/sqlcmd \
    -S localhost \
    -U sa \
    -P "$MSSQL_SA_PASSWORD" \
    -C \
    -Q "SELECT 1" > /dev/null 2>&1
do
    sleep 2
done

echo "SQL Server is ready."

echo "Checking AppointmentBookings database..."

DB_EXISTS=$(
    /opt/mssql-tools18/bin/sqlcmd \
        -S localhost \
        -U sa \
        -P "$MSSQL_SA_PASSWORD" \
        -C \
        -h -1 \
        -W \
        -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name = 'AppointmentBookings'"
)

if [ "$DB_EXISTS" = "1" ]; then

    echo "AppointmentBookings database already exists."
    echo "Skipping database initialization."

else

    echo "Creating AppointmentBookings database..."

    /opt/mssql-tools18/bin/sqlcmd \
        -S localhost \
        -U sa \
        -P "$MSSQL_SA_PASSWORD" \
        -C \
        -Q "CREATE DATABASE AppointmentBookings"

    echo "Database created."

    echo "Running database initialization script..."

    /opt/mssql-tools18/bin/sqlcmd \
        -S localhost \
        -U sa \
        -P "$MSSQL_SA_PASSWORD" \
        -C \
        -d AppointmentBookings \
        -i /usr/src/app/init.sql

    echo "Database initialization completed successfully."

fi

echo "=========================================="
echo " SQL Server startup complete"
echo "=========================================="

wait $SQLSERVER_PID