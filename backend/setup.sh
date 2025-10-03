# NMIT Portal Backend Setup Script
# Run this script to quickly set up the backend with local Oracle database

echo "🚀 NMIT Portal Backend Setup"
echo "================================"

# Check if Oracle is running
echo "📋 Checking Oracle Database..."

# For Windows
if command -v sqlplus &> /dev/null; then
    echo "✅ Oracle SQL*Plus found"
else
    echo "❌ Oracle SQL*Plus not found. Please install Oracle Database first."
    echo "   Download from: https://www.oracle.com/database/technologies/xe-downloads.html"
    exit 1
fi

# Test Oracle connection
echo "🔌 Testing Oracle connection..."
sqlplus -s system/your_system_password@localhost:1521/XE <<EOF
SELECT 'Oracle is running' FROM dual;
EXIT;
EOF

if [ $? -eq 0 ]; then
    echo "✅ Oracle Database is running"
else
    echo "❌ Cannot connect to Oracle Database"
    echo "   Please check:"
    echo "   1. Oracle Database is installed and running"
    echo "   2. Listener is running on port 1521"
    echo "   3. Database SID 'XE' exists"
    echo "   4. SYSTEM password is correct"
    exit 1
fi

# Create application user
echo "👤 Creating application user..."
sqlplus -s system/your_system_password@localhost:1521/XE @src/main/resources/db/create-user.sql

if [ $? -eq 0 ]; then
    echo "✅ Application user created successfully"
else
    echo "❌ Failed to create application user"
    exit 1
fi

# Create database schema
echo "🗄️ Creating database schema..."
sqlplus -s nmit_portal/nmit_portal_password@localhost:1521/XE @src/main/resources/db/schema.sql

if [ $? -eq 0 ]; then
    echo "✅ Database schema created successfully"
else
    echo "❌ Failed to create database schema"
    exit 1
fi

# Insert sample data
echo "📊 Inserting sample data..."
sqlplus -s nmit_portal/nmit_portal_password@localhost:1521/XE @src/main/resources/db/sample-data.sql

if [ $? -eq 0 ]; then
    echo "✅ Sample data inserted successfully"
else
    echo "❌ Failed to insert sample data"
    exit 1
fi

# Build the application
echo "🔨 Building the application..."
mvn clean compile

if [ $? -eq 0 ]; then
    echo "✅ Application built successfully"
else
    echo "❌ Failed to build application"
    exit 1
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. Start the application: mvn spring-boot:run"
echo "2. Access Swagger UI: http://localhost:8080/api/swagger-ui.html"
echo "3. Test login with: admin / admin123"
echo ""
echo "🔧 Configuration:"
echo "- Database URL: jdbc:oracle:thin:@localhost:1521:XE"
echo "- Application User: nmit_portal"
echo "- Server Port: 8080"
echo ""