# Oracle XE with Service Name "FREE" - Configuration Guide

## 🎯 **Oracle XE Service Name Setup**

Your Oracle XE database is using the service name **"FREE"** instead of the traditional SID **"XE"**. This is the new standard for Oracle Database XE 21c and later versions.

## 📋 **SQL Developer 23 AI Connection Setup**

### **Step 1: SYSTEM Connection**
1. **Open Oracle SQL Developer 23 AI**
2. **Right-click "Connections"** → **"New Connection"**
3. **Configure as follows**:
   - **Connection Name**: `NMIT_Portal_SYSTEM`
   - **Username**: `SYSTEM`
   - **Password**: `[Your SYSTEM password]`
   - **Connection Type**: `Basic`
   - **Hostname**: `localhost`
   - **Port**: `1521`
   - **Service name**: `FREE` ⚠️ **Important: Use Service name, not SID**
4. **Click "Test"** - Should show "Success"
5. **Click "Save"** and **"Connect"**

### **Step 2: Application User Connection**  
After creating the SYSTEM user, create the application connection:
1. **New Connection**: `NMIT_Portal_App`
2. **Username**: `nmit_portal`
3. **Password**: `nmit_portal_password`
4. **Hostname**: `localhost`
5. **Port**: `1521`
6. **Service name**: `FREE` ⚠️ **Important: Use Service name, not SID**

## 🔧 **Connection String Format**

The correct connection string format for Oracle XE with service name "FREE":

### **JDBC URL Format**:
```
jdbc:oracle:thin:@localhost:1521/FREE
```

### **SQL*Plus Format**:
```
sqlplus username/password@localhost:1521/FREE
```

### **TNS Format**:
```
username/password@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=FREE)))
```

## 🛠️ **Database Setup Commands**

### **Connect as SYSTEM**:
```sql
-- Using SQL*Plus
sqlplus system/your_system_password@localhost:1521/FREE

-- Using SQL Developer: Use the connection created above
```

### **Create Application User**:
```sql
-- Execute in SYSTEM connection
@C:\NMIT_PORTAL\backend\src\main\resources\db\sql-developer-setup.sql
```

### **Connect as Application User**:
```sql
-- Using SQL*Plus
sqlplus nmit_portal/nmit_portal_password@localhost:1521/FREE

-- Using SQL Developer: Use the NMIT_Portal_App connection
```

## 🔍 **Verification Commands**

### **Check Service Name**:
```sql
-- Run as SYSTEM to verify service name
SELECT name FROM v$services;
SELECT value FROM v$parameter WHERE name = 'service_names';
```

### **Check Database Version**:
```sql
SELECT banner FROM v$version;
```

### **Test Connection**:
```sql
SELECT 
    'Connected to: ' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
    ' as user: ' || USER ||
    ' via service: ' || SYS_CONTEXT('USERENV', 'SERVICE_NAME')
FROM DUAL;
```

## 📝 **Updated Setup Script**

Here's the corrected setup process:

### **Step 1: Database Setup**
```bash
# Connect and create user
sqlplus system/your_system_password@localhost:1521/FREE @src\main\resources\db\sql-developer-setup.sql

# Create schema
sqlplus nmit_portal/nmit_portal_password@localhost:1521/FREE @src\main\resources\db\schema.sql

# Insert sample data
sqlplus nmit_portal/nmit_portal_password@localhost:1521/FREE @src\main\resources\db\sample-data.sql
```

### **Step 2: Verify Setup**
```sql
-- Run in NMIT_Portal_App connection
@C:\NMIT_PORTAL\backend\src\main\resources\db\verify-setup.sql
```

## 🚀 **Start Application**

The application configuration is now updated to use the correct service name:

```bash
cd C:\NMIT_PORTAL\backend
mvn spring-boot:run -Dspring.profiles.active=local
```

## 🔧 **Configuration Files Updated**

All configuration files have been updated to use:
- **Service Name**: `FREE`
- **Connection URL**: `jdbc:oracle:thin:@localhost:1521/FREE`

### **Files Updated**:
- ✅ `application.properties`
- ✅ `application-local.properties`
- ✅ `application-test.properties`
- ✅ `setup.bat`

## 🚨 **Common Issues & Solutions**

### **Issue 1: "ORA-12514: TNS:listener does not currently know of service requested"**
**Solution**: You're using SID format instead of Service Name
- ❌ Wrong: `jdbc:oracle:thin:@localhost:1521:XE`
- ✅ Correct: `jdbc:oracle:thin:@localhost:1521/FREE`

### **Issue 2: Connection refused**
**Solution**: Check Oracle services are running
```cmd
# Windows
net start OracleServiceFREE
net start OracleOraDB21Home1TNSListener

# Or use Services.msc to start Oracle services
```

### **Issue 3: Service name not found**
**Solution**: Verify the actual service name
```sql
-- Connect as SYSTEM and check
SELECT name FROM v$services WHERE name LIKE '%FREE%';
```

## 📊 **Testing Your Setup**

### **1. Test Database Connection**
```sql
-- In SQL Developer NMIT_Portal_App connection
SELECT 'Database connection successful!' FROM DUAL;
```

### **2. Test Application Startup**
```bash
mvn spring-boot:run -Dspring.profiles.active=local
```

### **3. Test API Access**
- **Swagger UI**: http://localhost:8080/api/swagger-ui.html
- **Health Check**: http://localhost:8080/api/actuator/health

Your Oracle XE database with service name "FREE" is now properly configured for the NMIT Portal backend!