#!/bin/bash

# NMIT Portal Git Setup Script
echo "Setting up git repository for NMIT Course Registration Portal..."

# Navigate to project directory
cd /c/NMIT_PORTAL

# Initialize git repository
git init

# Configure git user (update with your details)
git config user.name "Abhishek JC"
git config user.email "abhishekjc19@gmail.com"

# Add all files to staging
git add .

# Create initial commit
git commit -m "Initial commit: NMIT Course Registration Portal

Features:
- React frontend with TypeScript and Tailwind CSS
- Spring Boot backend with Oracle Database
- Student authentication with USN/DOB
- Dashboard with CIE marks and attendance
- Complete database setup scripts
- JWT-based security implementation"

# Add remote repository
git remote add origin https://github.com/Abhishekjc19/NMIT_COURSEREGISTRATION.git

# Push to GitHub
git branch -M main
git push -u origin main

echo "✅ Code successfully pushed to GitHub!"
echo "🌐 Repository: https://github.com/Abhishekjc19/NMIT_COURSEREGISTRATION"