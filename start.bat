@echo off
REM KBT Project Startup Script for Windows
REM This script starts MongoDB, Backend, and Frontend

echo ========================================
echo Starting KBT Application...
echo ========================================
echo.

REM Start MongoDB (if installed as service)
echo Starting MongoDB...
net start MongoDB 2>nul
if %errorlevel% equ 0 (
    echo [OK] MongoDB started
) else (
    echo [INFO] MongoDB might already be running or not installed as a service
)
echo.

REM Start Backend
echo Starting Backend...
cd backend

REM Create virtual environment if it doesn't exist
if not exist "venv" (
    echo Creating Python virtual environment...
    python -m venv venv
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install dependencies if needed
if not exist "venv\.dependencies_installed" (
    echo Installing Python dependencies...
    pip install -r requirements.txt
    type nul > venv\.dependencies_installed
)

REM Check if .env exists
if not exist ".env" (
    echo Creating .env file...
    (
        echo MONGO_URI=mongodb://localhost:27017/
        echo MONGO_DB_NAME=kbt
        echo MODEL_NAME=meta-llama/Llama-3.2-1B
    ) > .env
)

REM Start backend
REM Note: Using 0.0.0.0 for development. For production, use 127.0.0.1 or configure properly.
echo Starting FastAPI server...
start "KBT Backend" cmd /k "uvicorn main:app --reload --host 0.0.0.0 --port 8000"

cd ..
echo [OK] Backend started
echo.

REM Wait a bit for backend to start
timeout /t 3 /nobreak >nul

REM Start Frontend
echo Starting Frontend...
cd frontend

REM Install dependencies if needed
if not exist "node_modules" (
    echo Installing npm dependencies...
    call npm install
)

REM Check if .env exists
if not exist ".env" (
    echo Creating .env file...
    echo BACKEND_URL=http://localhost:8000 > .env
)

REM Start frontend
echo Starting React development server...
start "KBT Frontend" cmd /k "npm run dev"

cd ..
echo [OK] Frontend started
echo.

echo ========================================
echo KBT Application is running!
echo ========================================
echo.
echo Access points:
echo   Frontend:  http://localhost:5173
echo   Backend:   http://localhost:8000
echo   API Docs:  http://localhost:8000/docs
echo.
echo Press any key to exit (services will continue running)...
pause >nul
