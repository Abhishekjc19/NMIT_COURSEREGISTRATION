# 📊 How to Import Your AIML Students Excel Data

## Step 1: Open Your Excel File
1. Open the Excel file: `AIML - 2027 Batch Student Details.xlsx`
2. Note down the column structure (USN, Name, Department, etc.)

## Step 2: Convert Excel Data to SQL

### Method 1: Manual Copy-Paste (Recommended)
1. **Copy student data from Excel**
2. **Use this SQL template for each student:**

```sql
-- For each student, replace the values with actual data from Excel:

-- Create user account (for login)
INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
VALUES (
    'ACTUAL_USN_FROM_EXCEL',           -- username = USN (e.g., '4nm27ai001')
    'ACTUAL_USN_FROM_EXCEL@nmit.edu.in', -- email based on USN
    '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', -- default password hash for 'student123'
    'FIRST_NAME_FROM_EXCEL',          -- first name
    'LAST_NAME_FROM_EXCEL',           -- last name  
    'PHONE_FROM_EXCEL',               -- phone number
    'STUDENT',                        -- role
    1,                                -- email verified
    'ADMIN'                           -- created by
);

-- Create student record
INSERT INTO students (user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) 
VALUES (
    (SELECT id FROM users WHERE username = 'ACTUAL_USN_FROM_EXCEL'),
    (SELECT id FROM departments WHERE code = 'AIML'),
    'ACTUAL_USN_FROM_EXCEL',          -- USN in uppercase
    'ADM2027XXX',                     -- admission number
    2027,                             -- batch year
    1,                                -- current semester
    0.0,                              -- initial CGPA
    DATE 'YYYY-MM-DD',                -- date of birth from Excel
    'GENDER_FROM_EXCEL',              -- Male/Female
    'ADDRESS_FROM_EXCEL',             -- address
    'PARENT_NAME_FROM_EXCEL',         -- parent name
    'PARENT_PHONE_FROM_EXCEL',        -- parent phone
    'PARENT_EMAIL_FROM_EXCEL',        -- parent email
    DATE '2027-08-01',                -- admission date
    'ACTIVE',                         -- status
    'ADMIN'                           -- created by
);
```

## Step 3: Update Login System for USN

### Current Login vs New USN Login:
- **Current**: Login with username like 'admin', 'faculty001'
- **New**: Login with USN like '4NM27AI001'

### Default Password for All Students:
- **Password**: `student123` (hashed in database)

## Step 4: Run the Import

1. **In SQL Developer** (SYSTEM or nmit_portal connection):
2. **First run**: `aiml-students-import.sql` (AIML department creation)
3. **Then run**: Your customized student data SQL

## Step 5: Test Login

After import, students can login with:
- **Username**: Their USN (e.g., `4NM27AI001`)
- **Password**: `student123`

## 📋 Example Data Format

If your Excel has columns like:
```
USN          | Name              | Phone      | Email                    | DOB        | Gender | Address
4NM27AI001   | John Doe          | 9876543001 | john@gmail.com          | 01-Jan-05  | Male   | Bangalore
4NM27AI002   | Jane Smith        | 9876543002 | jane@gmail.com          | 15-Feb-05  | Female | Mysore
```

Convert to:
```sql
INSERT INTO users VALUES ('4nm27ai001', '4nm27ai001@nmit.edu.in', '$2a$10$...', 'John', 'Doe', '9876543001', 'STUDENT', 1, 'ADMIN');
INSERT INTO students VALUES (..., '4NM27AI001', ...);
```

## 🚀 Next Steps:

1. **Open your Excel file**
2. **Copy the student data**
3. **Create SQL statements** using the template above
4. **Run in SQL Developer**
5. **Test login** with USN and 'student123' password

Would you like me to help you create the specific SQL statements once you share some sample data from your Excel file?