# NMIT Portal Backend

## Overview
This is the backend API for the NITTE Meenakshi Institute of Technology (NMIT) Portal, built with Spring Boot 3.2.0 and Java 17. The application provides comprehensive functionality for managing students, faculty, courses, results, placements, and admissions.

## Technology Stack
- **Framework**: Spring Boot 3.2.0
- **Language**: Java 17
- **Database**: Oracle Database
- **Authentication**: JWT (JSON Web Tokens)
- **Security**: Spring Security 6
- **Documentation**: OpenAPI 3 (Swagger)
- **Build Tool**: Maven

## Key Features
- **User Management**: Role-based authentication and authorization
- **Student Management**: Complete student lifecycle management
- **Faculty Management**: Faculty profiles and course assignments
- **Academic Records**: Course management and result processing
- **Placement Management**: Campus placement tracking
- **Admission Management**: Online admission applications
- **Reporting**: Academic and placement analytics

## Project Structure
```
src/
├── main/
│   ├── java/com/nmit/portal/
│   │   ├── config/          # Configuration classes
│   │   ├── controller/      # REST API controllers
│   │   ├── dto/            # Data Transfer Objects
│   │   ├── model/          # JPA entities
│   │   ├── repository/     # JPA repositories
│   │   ├── security/       # Security configuration
│   │   └── service/        # Business logic services
│   └── resources/
│       ├── db/             # Database scripts
│       └── application.properties
└── test/                   # Test classes
```

## Database Setup

### Prerequisites
1. **Oracle Database XE 21c or later** (with service name "FREE")
2. **Oracle SQL Developer 23 AI** (recommended) or SQL*Plus
3. **Database Access**: SYSTEM user credentials for initial setup

### Quick Setup Guide
For detailed Oracle XE with service name "FREE" setup, see: **[ORACLE_FREE_SETUP.md](ORACLE_FREE_SETUP.md)**

### Schema Creation
1. **Create application user** (run as SYSTEM):
   ```sql
   @src/main/resources/db/sql-developer-setup.sql
   ```

2. **Create schema** (run as nmit_portal user):
   ```sql
   @src/main/resources/db/schema.sql
   ```

3. **Insert sample data**:
   ```sql
   @src/main/resources/db/sample-data.sql
   ```

### Automated Setup (Windows)
```cmd
# Run the setup script (update paths as needed)
setup.bat
```

## Configuration

### Database Configuration
The application is configured for Oracle XE with service name "FREE":
```properties
# Oracle XE with Service Name (not SID)
spring.datasource.url=jdbc:oracle:thin:@localhost:1521/FREE
spring.datasource.username=nmit_portal
spring.datasource.password=nmit_portal_password
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver
```

### Connection String Format
- ✅ **Correct**: `jdbc:oracle:thin:@localhost:1521/FREE` (Service Name)
- ❌ **Incorrect**: `jdbc:oracle:thin:@localhost:1521:XE` (SID - old format)

### JWT Configuration
Configure JWT secret and expiration:
```properties
jwt.secret=NmitPortalSecretKeyForJWTTokenGenerationAndValidation2024
jwt.expiration=86400000
```

## Build and Run

### Using Maven
```bash
# Build the project
mvn clean compile

# Run tests
mvn test

# Package the application
mvn package

# Run the application
mvn spring-boot:run
```

### Using Java
```bash
# After packaging
java -jar target/nmit-portal-1.0.0.jar
```

## API Documentation
Once the application is running, access the API documentation at:
- Swagger UI: http://localhost:8080/api/swagger-ui.html
- OpenAPI JSON: http://localhost:8080/api/api-docs

## Authentication

### Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "usernameOrEmail": "admin",
  "password": "admin123"
}
```

### Sample Users
- **Admin**: username: `admin`, password: `admin123`
- **HOD CSE**: username: `hod_cse`, password: `hod123`
- **Faculty**: username: `faculty001`, password: `faculty123`
- **Student**: username: `4nm20cs001`, password: `student123`

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/change-password` - Change password
- `POST /api/auth/forgot-password` - Password reset request
- `POST /api/auth/reset-password` - Confirm password reset
- `GET /api/auth/me` - Get current user details

### Students
- `GET /api/students` - Get all students (paginated)
- `GET /api/students/{id}` - Get student by ID
- `GET /api/students/usn/{usn}` - Get student by USN
- `GET /api/students/my-profile` - Get current student's profile
- `POST /api/students` - Create new student
- `PUT /api/students/{id}` - Update student
- `DELETE /api/students/{id}` - Delete student

### Results
- `GET /api/results` - Get all results
- `GET /api/results/student/{studentId}` - Get results by student
- `GET /api/results/my-results` - Get current student's results
- `POST /api/results` - Create new result
- `PUT /api/results/{id}` - Update result

## Security Roles
- **ADMIN**: Full system access
- **HOD**: Department-level access
- **FACULTY**: Course and student management
- **STUDENT**: Personal data access
- **PLACEMENT_OFFICER**: Placement management

## Error Handling
The API returns standardized error responses:
```json
{
  "success": false,
  "message": "Error description",
  "data": null
}
```

## Development

### Prerequisites
- Java 17 or later
- Maven 3.6 or later
- Oracle Database
- IDE (IntelliJ IDEA, Eclipse, VS Code)

### Code Style
- Follow Java naming conventions
- Use Spring Boot best practices
- Implement proper exception handling
- Add appropriate logging

## Deployment

### Production Configuration
1. Update `application-prod.properties` with production database settings
2. Configure SSL/TLS certificates
3. Set up proper logging configuration
4. Configure monitoring and health checks

### Docker Deployment
```dockerfile
FROM openjdk:17-jre-slim
COPY target/nmit-portal-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

## Monitoring
- Health check endpoint: `GET /actuator/health`
- Application metrics available through Spring Boot Actuator

## Contributing
1. Follow the existing code structure
2. Write unit tests for new features
3. Update documentation for API changes
4. Follow security best practices

## Support
For technical support, contact the development team at: dev-team@nmit.edu.in