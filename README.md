# Appointment Booking System — Docker Deployment

This repository contains the Docker deployment setup for the Appointment Booking System.

The application consists of:

* **Frontend** — Next.js
* **API** — .NET 8
* **Database** — Microsoft SQL Server 2022
* **Docker Compose** — Runs the complete application stack
* **PowerShell setup script** — Automatically clones the frontend and API repositories

The deployment repository is responsible for bringing all three components together and running them with Docker.

---

## Repository Structure


appointment-booking-system-deployment/
│
├── api/
│   └── Dockerfile
│
├── database/
│   ├── dockerfile
│   ├── entrypoint.sh
│   └── init.sql
│
├── frontend/
│
├── .env
├── .gitignore
├── docker-compose.yml
├── README.md
└── setup.ps1


The `api` and `frontend` folders are populated automatically by `setup.ps1`.

The database initialization files are included in this deployment repository and are used when the SQL Server container is created.

---

# Prerequisites

Before starting, install the following:

### 1. Docker Desktop

Docker Desktop is required to build and run the containers.

Make sure Docker Desktop is running before continuing.

### 2. Git

Git is required because the setup script automatically clones the frontend and API repositories.

---

# Installation

## 1. Clone the Deployment Repository

Clone this repository:

powershell
git clone https://github.com/zaneadamomar/appointment-booking-system-deployment.git


Navigate into the repository:

powershell
cd appointment-booking-system-deployment


---

## 2. Run the Setup Script

Run:

powershell
.\setup.ps1


The setup script will:

1. Clone the frontend repository.
2. Clone the API repository.
3. Place the repositories into the required `frontend` and `api` folders.
4. Prepare the deployment structure for Docker Compose.

After the script completes, the directory should contain the application source code in:


frontend/
api/


---

# Environment Configuration

The repository uses a `.env` file for the SQL Server administrator password.

The `.env` file should contain:

env
SA_PASSWORD=YourStrongPasswordHere


Replace `YourStrongPasswordHere` with the password you want to use for the SQL Server `sa` account.

For example:

env
SA_PASSWORD=AppointmentDb2026!Strong


### Important

Do not commit passwords or other secrets to source control.

The `.env` file should remain excluded through `.gitignore`.

---

# Starting the Application

Once `setup.ps1` has completed, start the entire application using:

powershell
docker compose up --build


The first startup may take some time because Docker needs to:

* Build the SQL Server image.
* Build the .NET API image.
* Build the Next.js frontend image.
* Start SQL Server.
* Create the `AppointmentBookings` database.
* Run the database initialization script.
* Start the API.
* Start the frontend.

Once all services have started, open:

**Frontend**


http://localhost:3000


The application should now be available.

---

# Application URLs

| Component   | URL                           |
| ----------- | ----------------------------- |
| Frontend    | http://localhost:3000         |
| API         | http://localhost:8080         |
| API Swagger | http://localhost:8080/swagger |
| SQL Server  | localhost:1433                |

The frontend communicates with the API through:


http://localhost:8080


The API communicates with SQL Server internally through the Docker Compose service:


sqlserver:1433


---

# Running in the Background

To start the application without keeping the terminal open:

powershell
docker compose up --build -d


Check the running containers:

powershell
docker compose ps


View the application logs:

powershell
docker compose logs


To follow the logs continuously:

powershell
docker compose logs -f


To view logs for a specific service:

powershell
docker compose logs -f api


or:

powershell
docker compose logs -f frontend


or:

powershell
docker compose logs -f sqlserver


---

# Stopping the Application

To stop the containers:

powershell
docker compose down


This stops and removes the containers but keeps the SQL Server database volume.

The database data will therefore remain available the next time the application is started.

---

# Resetting the Database

If you need to completely reset the database and run `init.sql` again, use:

powershell
docker compose down -v


Then start the application again:

powershell
docker compose up --build


The `-v` option removes the Docker volumes, including the SQL Server data volume.

This causes SQL Server to start with an empty data directory.

The database container will then:

1. Create the `AppointmentBookings` database.
2. Execute `init.sql`.
3. Create the tables.
4. Insert the initial data.
5. Create the stored procedures.

### Warning

Using:

powershell
docker compose down -v


will delete the existing Docker database data.

Only use this when you intentionally want to reset the database.

---

# Database Initialization

The database initialization is handled automatically.

The SQL Server container uses:

database/
├── dockerfile
├── entrypoint.sh
└── init.sql


The `entrypoint.sh` script waits for SQL Server to become available.

It then checks whether the `AppointmentBookings` database already exists.

### If the database does not exist

The script:

Create AppointmentBookings
        ↓
Run init.sql
        ↓
Create tables
        ↓
Insert initial data
        ↓
Create stored procedures


### If the database already exists

The initialization script is skipped.

This prevents the database from being recreated every time the containers restart.

---

# Application Services

Docker Compose runs three main services.

## SQL Server

The SQL Server container provides the application database.

The database is named:


AppointmentBookings

The SQL Server administrator account is:


Username: sa
Password: Value configured in .env


---

## API

The API is an ASP.NET Core .NET 8 application.

It runs inside Docker on:


http://localhost:8080


The API connects to SQL Server using the Docker service name:


sqlserver


rather than the SQL Server instance installed on the host machine.

---

## Frontend

The frontend is a Next.js application.

It runs on:


http://localhost:3000


The frontend is configured to communicate with the Dockerized API at:


http://localhost:8080


---

# Updating the Application

If the frontend or API repositories have been updated, run the setup process again according to the repository's `setup.ps1` workflow.

After updating the source code, rebuild the Docker images:

powershell
docker compose up --build


To force a completely fresh image build:

powershell
docker compose build --no-cache


Then start the containers:

powershell
docker compose up


---

# Troubleshooting

## Docker is not running

If you receive an error indicating that Docker cannot connect to the Docker daemon, start Docker Desktop and try again.

---

## Port 3000 is already in use

Check which application is using port `3000`.

You can stop the existing application or change the frontend port in `docker-compose.yml`.

---

## Port 8080 is already in use

Check which application is using port `8080`.

You can stop the existing application or change the API host port in `docker-compose.yml`.

The API will still use port `8080` internally.

---

## SQL Server does not start

Check the SQL Server logs:

powershell
docker compose logs sqlserver


Make sure the `SA_PASSWORD` in `.env` meets SQL Server's password requirements.

---

## Database was not initialized

If the database was previously created, `init.sql` will not run again automatically.

To completely reset the database:

powershell
docker compose down -v


Then:

powershell
docker compose up --build


---

## Checking Container Status

Run:

powershell
docker compose ps


You should see the three application services running:


sqlserver
api
frontend


---

# Quick Start

For a new machine, the complete process is:

### 1. Clone the deployment repository

powershell
git clone https://github.com/zaneadamomar/appointment-booking-system-deployment.git


### 2. Enter the repository

powershell
cd appointment-booking-system-deployment


### 3. Run the setup script

powershell
.\setup.ps1


### 4. Configure `.env`

env
SA_PASSWORD=YourStrongPasswordHere


### 5. Build and start Docker

powershell
docker compose up --build


### 6. Open the application


http://localhost:3000


That's it.

The setup script handles obtaining the application repositories, while Docker Compose handles the frontend, API and SQL Server containers.
