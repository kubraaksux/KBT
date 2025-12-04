#!/bin/bash

# KBT Project Stop Script
# This script stops the Backend and Frontend processes

set -e

echo "🛑 Stopping KBT Application..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Stop Backend
if [ -f "backend.pid" ]; then
    BACKEND_PID=$(cat backend.pid)
    if ps -p $BACKEND_PID > /dev/null; then
        echo -e "Stopping Backend (PID: $BACKEND_PID)..."
        kill -TERM $BACKEND_PID 2>/dev/null
        
        # Wait up to 5 seconds for graceful shutdown
        for i in {1..5}; do
            if ! ps -p $BACKEND_PID > /dev/null 2>&1; then
                break
            fi
            sleep 1
        done
        
        # Force kill if still running
        if ps -p $BACKEND_PID > /dev/null 2>&1; then
            echo -e "  Forcing shutdown..."
            kill -KILL $BACKEND_PID 2>/dev/null
        fi
        
        rm backend.pid
        echo -e "${GREEN}✓ Backend stopped${NC}"
    else
        echo -e "${RED}Backend process not found${NC}"
        rm backend.pid
    fi
else
    echo "No backend.pid file found"
fi

# Stop Frontend
if [ -f "frontend.pid" ]; then
    FRONTEND_PID=$(cat frontend.pid)
    if ps -p $FRONTEND_PID > /dev/null; then
        echo -e "Stopping Frontend (PID: $FRONTEND_PID)..."
        kill -TERM $FRONTEND_PID 2>/dev/null
        
        # Wait up to 5 seconds for graceful shutdown
        for i in {1..5}; do
            if ! ps -p $FRONTEND_PID > /dev/null 2>&1; then
                break
            fi
            sleep 1
        done
        
        # Force kill if still running
        if ps -p $FRONTEND_PID > /dev/null 2>&1; then
            echo -e "  Forcing shutdown..."
            kill -KILL $FRONTEND_PID 2>/dev/null
        fi
        
        rm frontend.pid
        echo -e "${GREEN}✓ Frontend stopped${NC}"
    else
        echo -e "${RED}Frontend process not found${NC}"
        rm frontend.pid
    fi
else
    echo "No frontend.pid file found"
fi

echo ""
echo -e "${GREEN}✓ KBT Application stopped${NC}"
echo ""
echo "Note: MongoDB is still running. To stop it:"
echo "  macOS:  brew services stop mongodb-community"
echo "  Linux:  sudo systemctl stop mongod"
echo "  Docker: docker stop kbt-mongodb"
