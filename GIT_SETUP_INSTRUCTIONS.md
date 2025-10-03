# Git Setup Instructions for NMIT Course Registration Portal

## 🚀 Quick Push to GitHub

### Method 1: Using Command Line (Recommended)

1. **Open Terminal/Command Prompt as Administrator**
2. **Navigate to project directory:**
   ```bash
   cd C:\NMIT_PORTAL
   ```

3. **Run the automated script:**
   ```bash
   # For Windows
   push-to-github.bat
   
   # For Git Bash
   bash push-to-github.sh
   ```

### Method 2: Manual Steps

1. **Initialize Git Repository:**
   ```bash
   cd C:\NMIT_PORTAL
   git init
   ```

2. **Configure Git User:**
   ```bash
   git config user.name "Abhishek JC"
   git config user.email "abhishekjc19@gmail.com"
   ```

3. **Add Files:**
   ```bash
   git add .
   ```

4. **Create Initial Commit:**
   ```bash
   git commit -m "Initial commit: NMIT Course Registration Portal

   Features:
   - React frontend with TypeScript and Tailwind CSS
   - Spring Boot backend with Oracle Database
   - Student authentication with USN/DOB
   - Dashboard with CIE marks and attendance
   - Complete database setup scripts
   - JWT-based security implementation"
   ```

5. **Add Remote and Push:**
   ```bash
   git remote add origin https://github.com/Abhishekjc19/NMIT_COURSEREGISTRATION.git
   git branch -M main
   git push -u origin main
   ```

## 📁 What's Being Pushed

### Frontend (React + TypeScript)
- `/project/` - Complete React application
- Modern UI with Tailwind CSS
- Student dashboard and authentication
- Responsive design and charts

### Backend (Spring Boot + Java)
- `/backend/` - Complete Spring Boot application
- JWT authentication system
- Oracle database integration
- RESTful API endpoints

### Database Setup
- `FIX-DATABASE-FINAL.sql` - Complete database schema
- Sample student data (USN: 1NT23AI004)
- Oracle-specific setup scripts

### Configuration
- `.gitignore` - Proper exclusions for Java/Node.js
- `README.md` - Comprehensive documentation
- Vite and Maven configurations

## 🔐 Authentication Info (for testing)
- **USN:** 1NT23AI004
- **DOB:** 19/04/2004

## 🌐 Repository URL
https://github.com/Abhishekjc19/NMIT_COURSEREGISTRATION

---

**Note:** Make sure you have push access to the repository. If it's a new repository, you may need to create it on GitHub first or ensure your credentials are set up properly.