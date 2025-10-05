#!/bin/bash
# Fix USERS table by adding missing columns

echo "========================================"
echo "FIXING USERS TABLE SCHEMA"
echo "========================================"
echo ""
echo "Connecting to Oracle Database..."
echo ""

cd "$(dirname "$0")"

sqlplus -S nmit_portal/nmit_portal_password@localhost:1521/FREE @QUICK-FIX-USERS.sql

echo ""
echo "========================================"
echo "DONE! Check output above for any errors"
echo "========================================"
echo ""
