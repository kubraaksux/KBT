#!/bin/bash

# KBT Project Startup Script
# This script starts MongoDB, Backend, and Frontend in the correct order

set -e

echo "🚀 Starting KBT Application..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if MongoDB is already running
if pgrep -x "mongod" > /dev/null; then
    echo -e "${GREEN}✓ MongoDB is already running${NC}"
else
    echo -e "${YELLOW}Starting MongoDB...${NC}"
    
    # Try to start MongoDB based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if ! brew services start mongodb-community 2>/dev/null; then
            echo "⚠️  Please install MongoDB via: brew install mongodb-community"
            echo "Or start it manually before running this script"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux - try systemctl first
        if ! sudo systemctl start mongod 2>/dev/null; then
            echo "⚠️  MongoDB is not installed as a service."
            echo "Please install MongoDB or use Docker:"
            echo "  docker run -d -p 27017:27017 --name kbt-mongodb mongo:latest"
        fi
    fi
    
    sleep 2
    echo -e "${GREEN}✓ MongoDB startup attempted${NC}"
fi

echo ""

# Start Backend
echo -e "${YELLOW}Starting Backend...${NC}"
cd backend

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies if needed
if [ ! -f "venv/.dependencies_installed" ]; then
    echo "Installing Python dependencies..."
    pip install -r requirements.txt
    touch venv/.dependencies_installed
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cat > .env << EOF
MONGO_URI=mongodb://localhost:27017/
MONGO_DB_NAME=kbt
MODEL_NAME=meta-llama/Llama-3.2-1B
EOF
fi

# Start backend in background
echo "Starting FastAPI server..."
uvicorn main:app --reload --host 0.0.0.0 --port 8000 > ../backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../backend.pid

cd ..
echo -e "${GREEN}✓ Backend started (PID: $BACKEND_PID)${NC}"
echo ""

# Start Frontend
echo -e "${YELLOW}Starting Frontend...${NC}"
cd frontend

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing npm dependencies..."
    npm install
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cat > .env << EOF
BACKEND_URL=http://localhost:8000
EOF
fi

# Start frontend in background
echo "Starting React development server..."
npm run dev > ../frontend.log 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > ../frontend.pid

cd ..
echo -e "${GREEN}✓ Frontend started (PID: $FRONTEND_PID)${NC}"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}🎉 KBT Application is running!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📍 Access points:"
echo "   Frontend:  http://localhost:5173"
echo "   Backend:   http://localhost:8000"
echo "   API Docs:  http://localhost:8000/docs"
echo ""
echo "📝 Logs:"
echo "   Backend:   tail -f backend.log"
echo "   Frontend:  tail -f frontend.log"
echo ""
echo "🛑 To stop the application, run: ./stop.sh"
echo ""
