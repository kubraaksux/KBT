# KBT - Knowledge-Based Chat Application

## 🎯 Purpose

KBT (Knowledge-Based Tutor) is a full-stack AI-powered chat application that allows users to interact with a Large Language Model (LLM) for intelligent conversations. The application maintains chat history and provides a seamless user experience through a modern web interface.

## 📋 What is this project?

This project demonstrates:
- **AI Chat System**: Integration with transformer-based language models for intelligent conversations
- **Full-stack Architecture**: Modern separation of concerns with a Python FastAPI backend and React frontend
- **Data Persistence**: MongoDB integration for storing users and chat histories
- **Real-time Interactions**: Chat interface that maintains conversation context across messages

## 🏗️ Architecture

### Backend
- **Framework**: FastAPI (Python)
- **Database**: MongoDB
- **AI/ML**: Hugging Face Transformers (LLaMA-based models)
- **Key Features**:
  - User management endpoints
  - Chat management with conversation history
  - AI-powered response generation using LLM

### Frontend
- **Framework**: React Router v7
- **Language**: TypeScript
- **Styling**: TailwindCSS
- **Features**:
  - User listing and selection
  - Interactive chat interface
  - Real-time message updates

## 🚀 Getting Started

### ⚡ Quick Start (Easiest Way)

**Option 1: Using Startup Scripts** (Recommended)

Run everything with a single command:

- **macOS/Linux**:
  ```bash
  ./start.sh
  ```

- **Windows**:
  ```bash
  start.bat
  ```

The script will automatically:
- Start MongoDB
- Create and activate Python virtual environment
- Install all dependencies
- Create .env files with default configuration
- Start backend on http://localhost:8000
- Start frontend on http://localhost:5173

To stop everything: `./stop.sh` (macOS/Linux)

**Option 2: Using Docker Compose**

If you have Docker installed:

```bash
docker-compose up
```

This starts MongoDB, backend, and frontend in containers. Access at http://localhost:5173

**Note**: The frontend in the browser will connect to the backend at http://localhost:8000 (not the Docker internal network).

To stop: `docker-compose down`

**Option 3: Manual Setup** (see detailed instructions below)

---

### Prerequisites

Before you begin, ensure you have the following installed:

#### For Backend:
- Python 3.8 or higher
- pip (Python package manager)
- MongoDB (local or cloud instance)
- Sufficient RAM/GPU for running LLM models (recommended: 8GB+ RAM)

#### For Frontend:
- Node.js 18.x or higher
- npm (comes with Node.js)

## 🚦 Manual Setup (All Components)

Here's how to start the complete project with MongoDB, backend, and frontend:

### Step 1: Start MongoDB

**Option A: Using MongoDB locally (recommended for development)**

1. **Install MongoDB Community Edition**:
   - **macOS** (using Homebrew):
     ```bash
     brew tap mongodb/brew
     brew install mongodb-community
     ```
   - **Ubuntu/Debian**: Follow the [official MongoDB installation guide](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/) or use Docker:
     ```bash
     docker run -d -p 27017:27017 --name mongodb mongo:latest
     ```
   - **Windows**: Download from [MongoDB Download Center](https://www.mongodb.com/try/download/community)

2. **Start MongoDB**:
   - **macOS** (using Homebrew):
     ```bash
     brew services start mongodb-community
     ```
   - **Ubuntu/Debian** (if installed via package manager):
     ```bash
     sudo systemctl start mongod
     ```
   - **Docker** (any platform) - MongoDB should already be running from the docker run command above. Verify with:
     ```bash
     docker ps
     ```
   - **Windows**: MongoDB runs as a Windows service automatically after installation. To verify it's running, check Services or run:
     ```bash
     net start MongoDB
     ```

3. **Verify MongoDB is running**:
   ```bash
   mongosh
   # You should see a MongoDB shell prompt
   ```

**Option B: Using MongoDB Atlas (cloud, free tier available)**
1. Create a free account at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a cluster:
   - Select "Shared" (free tier)
   - Choose your preferred cloud provider and region
   - Click "Create Cluster"
3. Set up database access:
   - Go to "Database Access" and add a new user with username/password
   - Go to "Network Access" and add your IP address (or `0.0.0.0/0` for development only - ⚠️ not recommended for production as it allows access from anywhere)
4. Get your connection string:
   - Click "Connect" on your cluster
   - Choose "Connect your application"
   - Copy the connection string (format: `mongodb+srv://<username>:<password>@cluster.xxxxx.mongodb.net/`)
   - Replace `<username>` and `<password>` with your database user credentials
5. Use this connection string as `MONGO_URI` in your backend `.env` file

### Step 2: Start the Backend

1. **Navigate to backend directory and create virtual environment**:
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Create `.env` file** in the `backend` directory:
   ```env
   MONGO_URI=mongodb://localhost:27017/
   MONGO_DB_NAME=kbt
   MODEL_NAME=meta-llama/Llama-3.2-1B
   ```

4. **Start the backend server**:
   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```
   
   ✅ Backend will be running at `http://localhost:8000`

### Step 3: Start the Frontend

Open a **new terminal window** (keep backend running):

1. **Navigate to frontend directory**:
   ```bash
   cd frontend
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Create `.env` file** in the `frontend` directory:
   ```env
   BACKEND_URL=http://localhost:8000
   ```

4. **Start the development server**:
   ```bash
   npm run dev
   ```
   
   ✅ Frontend will be running at `http://localhost:5173`

### 🎉 Access the Application

Open your browser and navigate to:
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs (FastAPI auto-generated documentation)

---

## 📖 Detailed Setup Instructions

### 🔧 Backend Setup

1. **Navigate to backend directory**:
   ```bash
   cd backend
   ```

2. **Create a virtual environment** (recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables**:
   Create a `.env` file in the `backend` directory with the following variables:
   ```env
   MONGO_URI=mongodb://localhost:27017/  # Your MongoDB connection string
   MONGO_DB_NAME=kbt                      # Your database name
   MODEL_NAME=meta-llama/Llama-3.2-1B    # Hugging Face model name
   ```

   **Important Notes**:
   - Replace `MONGO_URI` with your MongoDB connection string (local or cloud like MongoDB Atlas)
   - Choose an appropriate model for `MODEL_NAME` based on your hardware capabilities
   - First-time model download may take time depending on model size

5. **Start the backend server**:
   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

   The backend API will be available at `http://localhost:8000`

### 🎨 Frontend Setup

1. **Navigate to frontend directory**:
   ```bash
   cd frontend
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure environment variables**:
   Create a `.env` file in the `frontend` directory:
   ```env
   BACKEND_URL=http://localhost:8000
   ```

4. **Start the development server**:
   ```bash
   npm run dev
   ```

   The frontend application will be available at `http://localhost:5173`

## 📚 API Endpoints

### User Routes (`/users`)
- `GET /users/` - Get all users
- `GET /users/{id}` - Get a specific user by ID
- `GET /users/{id}/chats` - Get all chats for a specific user

### Chat Routes (`/chats`)
- `GET /chats/{id}` - Get a specific chat by ID
- `POST /chats/{id}/answer` - Send a message and get AI-generated response
  - Body: `{ "query": "your message here" }`

## 🗂️ Project Structure

```
KBT/
├── backend/
│   ├── config/
│   │   ├── db.py           # MongoDB connection
│   │   └── model.py        # LLM model initialization
│   ├── routes/
│   │   ├── users.py        # User endpoints
│   │   └── chats.py        # Chat endpoints
│   ├── main.py             # FastAPI application entry point
│   └── requirements.txt    # Python dependencies
├── frontend/
│   ├── app/
│   │   ├── routes/         # React Router pages
│   │   ├── components/     # Reusable UI components
│   │   └── types.tsx       # TypeScript type definitions
│   ├── package.json        # Node dependencies
│   └── vite.config.ts      # Vite configuration
└── README.md               # This file
```

## 🎯 Where is it going? (Roadmap)

### Current Features
- ✅ User management system
- ✅ Chat history storage
- ✅ AI-powered chat responses with context awareness
- ✅ Modern, responsive UI

### Planned Features
- 🔲 User authentication and authorization
- 🔲 Create new users and chats from the UI
- 🔲 Multiple chat sessions per user
- 🔲 Chat deletion and management
- 🔲 Model selection and customization
- 🔲 Export chat history
- 🔲 Improved error handling and validation
- 🔲 Real-time streaming responses
- 🔲 File upload and document analysis
- 🔲 Deployment guides (Docker, Cloud platforms)

## 🛠️ Development

### Running Tests
```bash
# Backend (when tests are added)
cd backend
pytest

# Frontend
cd frontend
npm test
```

### Building for Production

**Backend**:
The FastAPI application is production-ready. Use a production ASGI server:
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

**Frontend**:
```bash
cd frontend
npm run build
npm run start
```

## 📝 Notes

- First run will download the LLM model, which may take significant time
- Ensure MongoDB is running before starting the backend
- Model inference requires adequate computational resources
- For production use, consider using GPU acceleration for better LLM performance

## 🤝 Contributing

This project is in active development. Contributions, issues, and feature requests are welcome!

## 📄 License

[Add your license information here]

---

Built with ❤️ using FastAPI, React Router, and Hugging Face Transformers
