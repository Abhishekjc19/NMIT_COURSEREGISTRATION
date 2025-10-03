# Oracle SQL Developer 23 AI - NMIT Portal Guide

## Leveraging SQL Developer 23 AI Features

### 1. **AI-Powered SQL Generation**
Use the AI chat feature to generate queries:

**Example Prompts:**
```
"Show me all students with CGPA above 8.5"
"Find the top 3 departments by student count"
"List all placement records for CSE students"
"Generate a report of faculty by department"
```

### 2. **Data Modeler Integration**
- Go to **View** → **Data Modeler** → **Browser**
- Import existing schema: **File** → **Data Modeler** → **Import** → **Data Dictionary**
- Select NMIT_PORTAL schema to visualize ERD

### 3. **Smart Code Completion**
SQL Developer 23 AI provides intelligent code completion for:
- Table names and columns
- Functions and procedures
- SQL syntax suggestions

### 4. **Database Monitoring Dashboard**
- **View** → **DBA** → **Dashboard**
- Monitor database performance
- Track connection usage
- View SQL execution statistics

## Useful SQL Developer Features for NMIT Portal

### 1. **Connection Organization**
Create connection folders:
```
📁 NMIT Portal Project
  ├── 🔗 NMIT_Portal_SYSTEM (Admin connection)
  ├── 🔗 NMIT_Portal_App (Application connection)
  └── 🔗 NMIT_Portal_Test (Testing connection)
```

### 2. **Code Templates**
Create custom code templates for common operations:

**Template: Insert Student**
```sql
INSERT INTO students (
    user_id, department_id, usn, admission_number, 
    batch_year, current_semester, date_of_birth, 
    gender, created_by
) VALUES (
    ${user_id}, ${dept_id}, '${usn}', '${admission_no}',
    ${batch_year}, ${semester}, DATE '${dob}',
    '${gender}', 'ADMIN'
);
```

### 3. **Query Results Export**
Export query results for reporting:
- Right-click on results → **Export**
- Choose format: Excel, CSV, JSON, XML
- Perfect for generating student reports

### 4. **SQL History and Favorites**
- **View** → **SQL History** - Track all executed queries
- **View** → **Snippets** - Save frequently used queries

## Database Administration Tasks

### 1. **Performance Monitoring**
```sql
-- Monitor active sessions
SELECT 
    username,
    status,
    machine,
    program,
    logon_time
FROM v$session
WHERE username = 'NMIT_PORTAL';

-- Check table sizes
SELECT 
    table_name,
    num_rows,
    avg_row_len,
    ROUND((num_rows * avg_row_len)/1024/1024, 2) as size_mb
FROM user_tables
WHERE num_rows > 0
ORDER BY size_mb DESC;
```

### 2. **Index Management**
```sql
-- Check existing indexes
SELECT 
    index_name,
    table_name,
    uniqueness,
    status
FROM user_indexes
ORDER BY table_name;

-- Analyze performance
SELECT 
    table_name,
    index_name,
    blevel,
    leaf_blocks,
    distinct_keys
FROM user_indexes
WHERE table_name IN ('USERS', 'STUDENTS', 'RESULTS');
```

### 3. **Data Backup and Recovery**
Use SQL Developer's Export/Import wizards:
- **Tools** → **Database Export** - Full schema backup
- **Tools** → **Database Import** - Restore from backup

## Productivity Tips

### 1. **Keyboard Shortcuts**
- `F5` - Execute single statement
- `Ctrl+Enter` - Execute script
- `Ctrl+Shift+F` - Format SQL
- `F4` - Describe object
- `Ctrl+Space` - Code completion

### 2. **Custom Reports**
Create custom reports for NMIT Portal:

**Report: Department Statistics**
```sql
SELECT 
    d.name as Department,
    COUNT(s.id) as Total_Students,
    AVG(s.cgpa) as Avg_CGPA,
    COUNT(f.id) as Total_Faculty
FROM departments d
LEFT JOIN students s ON d.id = s.department_id
LEFT JOIN faculty f ON d.id = f.department_id
GROUP BY d.name
ORDER BY Total_Students DESC;
```

### 3. **SQL Worksheet Organization**
Create separate worksheets for different modules:
- **Student Management Queries**
- **Result Processing Queries**
- **Placement Reports**
- **Administrative Tasks**

## Troubleshooting Common Issues

### 1. **Connection Issues**
```sql
-- Test connection
SELECT USER FROM DUAL;

-- Check database status
SELECT status FROM v$instance;
```

### 2. **Permission Issues**
```sql
-- Check user privileges
SELECT * FROM user_sys_privs ORDER BY privilege;

-- Check role privileges
SELECT * FROM user_role_privs;
```

### 3. **Performance Issues**
```sql
-- Find slow queries
SELECT 
    sql_text,
    executions,
    avg_timer_wait/1000000 as avg_time_ms
FROM performance_schema.events_statements_summary_by_digest
WHERE avg_timer_wait > 1000000000
ORDER BY avg_time_ms DESC;
```

## Best Practices

### 1. **Connection Management**
- Use connection pools for application connections
- Keep separate connections for admin and app users
- Regular connection cleanup

### 2. **SQL Development**
- Always test queries in SQL Developer before adding to application
- Use bind variables for parameterized queries
- Format SQL code for readability

### 3. **Data Management**
- Regular backups before major changes
- Use transactions for data modifications
- Monitor database growth and performance

This guide helps you leverage Oracle SQL Developer 23 AI's powerful features for managing your NMIT Portal database efficiently.