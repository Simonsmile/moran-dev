#!/bin/bash

# =============================================================================
# init.sh - Moran ERP Project Initialization Script
# =============================================================================
# Run this script at the start of every session to ensure the environment
# is properly set up and the development services are running.
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}Initializing Moran ERP project...${NC}"

# Check Docker
echo -e "${BLUE}Checking Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Create Docker network if not exists
if ! docker network inspect innernet &> /dev/null; then
    echo "Creating Docker network 'innernet'..."
    docker network create innernet
fi

# Start middleware containers (PostgreSQL, Redis, RabbitMQ)
echo -e "${BLUE}Starting middleware containers...${NC}"
if command -v docker-compose &> /dev/null; then
    # Check if docker-compose files exist in linux-server directory
    if [ -d "linux-server" ]; then
        echo "Middleware containers should be started manually from linux-server directory"
        echo "Required containers: db (PostgreSQL), redis, rabbitmq"
    fi
else
    echo "docker-compose not found, skipping container startup"
fi

# Backend setup
echo -e "${BLUE}Setting up backend...${NC}"
if [ -d "moran-erp" ]; then
    cd moran-erp
    if [ -f "mvnw" ]; then
        ./mvnw clean compile -DskipTests
    elif command -v mvn &> /dev/null; then
        mvn clean compile -DskipTests
    fi
    cd ..
else
    echo "Backend project not found. Will be created in Task 1."
fi

# Frontend setup
echo -e "${BLUE}Setting up frontend...${NC}"
if [ -d "moran-web" ]; then
    cd moran-web
    npm install
    cd ..
else
    echo "Frontend project not found. Will be created in Task 2."
fi

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}✓ Initialization complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "Project Structure:"
echo "  - Backend:  moran-erp/ (Java 21 + Spring Boot 3.4)"
echo "  - Frontend: moran-web/ (Vue 3 + TypeScript)"
echo ""
echo "Next steps:"
echo "  1. Read task.json to find the next task"
echo "  2. Read architecture.md for design guidance"
echo "  3. Implement the task following CLAUDE.md workflow"
echo ""
echo "Ready to continue development."
