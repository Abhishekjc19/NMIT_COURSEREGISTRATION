# Oracle Database Setup Guide for NMIT Portal

## Prerequisites
- Oracle Database (XE, Standard, or Enterprise Edition)
- Oracle SQL Developer or SQL*Plus
- Oracle JDBC Driver (included in Maven dependencies)

## Step-by-Step Setup

### 1. Install Oracle Database
**For Development (Recommended): Oracle Database XE**
- Download from: https://www.oracle.com/database/technologies/xe-downloads.html
- Install with default settings
- Remember the SYSTEM password you set during installation

### 2. Start Oracle Database Services
**Windows:**
```cmd
# Start Oracle services
net start OracleServiceXE
net start OracleXETNSListener
```

**Linux/Mac:**
```bash
# Start Oracle services
sudo service oracle-xe start
```

### 3. Connect and Create Application User
**Using SQL*Plus:**
```sql
# Connect as SYSTEM
sqlplus system/your_system_password@localhost:1521/XE

# Run the user creation script
@C:\NMIT_PORTAL\backend\src\main\resources\db\create-user.sql
```

**Using SQL Developer:**
1. Create connection: localhost:1521:XE with SYSTEM user
2. Open and execute `create-user.sql`

### 4. Create Database Schema
```sql
# Connect as nmit_portal user
CONNECT nmit_portal/nmit_portal_password@localhost:1521/XE

# Run schema creation
@C:\NMIT_PORTAL\backend\src\main\resources\db\schema.sql

# Insert sample data
@C:\NMIT_PORTAL\backend\src\main\resources\db\sample-data.sql
```

### 5. Verify Database Setup
```sql
-- Check tables are created
SELECT table_name FROM user_tables ORDER BY table_name;

-- Check sample data
SELECT COUNT(*) as user_count FROM users;
SELECT COUNT(*) as student_count FROM students;
SELECT COUNT(*) as department_count FROM departments;
```

## Configuration Options

### Connection URL Variations
Depending on your Oracle setup, use the appropriate connection URL:

**Oracle XE (Default):**
```
spring.datasource.url=jdbc:oracle:thin:@localhost:1521:XE
```

**Oracle 12c/19c with PDB:**
```
spring.datasource.url=jdbc:oracle:thin:@localhost:1521/XEPDB1
```

**Oracle with Service Name:**
```
spring.datasource.url=jdbc:oracle:thin:@localhost:1521/orcl
```

**Remote Oracle Database:**
```
spring.datasource.url=jdbc:oracle:thin:@your-server:1521:XE
```

### Common Connection Issues

**Issue 1: TNS Listener not running**
```bash
# Windows
net start OracleXETNSListener

# Linux
sudo service oracle-xe start
```

**Issue 2: User doesn't exist**
- Verify user creation using SYSTEM account
- Check user privileges

**Issue 3: Connection timeout**
- Verify Oracle listener is running on correct port
- Check firewall settings

## Running the Application

### 1. Set Active Profile
Create environment variable or add to IDE:
```
SPRING_PROFILES_ACTIVE=local
```

### 2. Build and Run
```bash
cd C:\NMIT_PORTAL\backend
mvn clean compile
mvn spring-boot:run
```

### 3. Verify Application
- API Base URL: http://localhost:8080/api
- Swagger UI: http://localhost:8080/api/swagger-ui.html
- Health Check: http://localhost:8080/api/actuator/health

## Troubleshooting

### Database Connection Test
```java
// Add this to a test file to verify connection
@Test
public void testDatabaseConnection() {
    try (Connection conn = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE", 
        "nmit_portal", 
        "nmit_portal_password")) {
        assertTrue(conn.isValid(5));
    }
}
```

### Common SQL Commands
```sql
-- Check Oracle version
SELECT * FROM v$version;

-- Check database status
SELECT status FROM v$instance;

-- View all users
SELECT username FROM dba_users ORDER BY username;

-- Check tablespace usage
SELECT 
    tablespace_name,
    ROUND(bytes/1024/1024, 2) as size_mb,
    ROUND(maxbytes/1024/1024, 2) as max_size_mb
FROM dba_data_files;
```

## Performance Tuning

### Oracle Configuration
```sql
-- Increase processes if needed
ALTER SYSTEM SET processes=200 SCOPE=spfile;

-- Increase memory if available
ALTER SYSTEM SET sga_target=512M SCOPE=spfile;
ALTER SYSTEM SET pga_aggregate_target=256M SCOPE=spfile;
```

### Application Configuration
```properties
# Connection pool tuning
spring.datasource.hikari.maximum-pool-size=15
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000
```

## Backup and Maintenance

### Database Backup
```bash
# Export schema
exp nmit_portal/nmit_portal_password@XE file=nmit_portal_backup.dmp

# Import schema
imp nmit_portal/nmit_portal_password@XE file=nmit_portal_backup.dmp
```

### Regular Maintenance
```sql
-- Analyze tables for better performance
EXEC DBMS_STATS.GATHER_SCHEMA_STATS('NMIT_PORTAL');

-- Check for invalid objects
SELECT object_name, object_type FROM user_objects WHERE status = 'INVALID';
```