# -------- BUILD STAGE --------
FROM maven:3.9.9-eclipse-temurin-11 AS build

WORKDIR /app

# Copy project files
COPY . .

# Build the application (skip tests for faster builds if needed)
RUN mvn clean install -DskipTests


# -------- RUN STAGE --------
FROM tomcat:9.0-jdk11-temurin

LABEL project="Vprofile"
LABEL author="Imran"

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from build stage
COPY --from=build /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# Expose application port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]