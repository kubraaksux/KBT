from dotenv import load_dotenv  
load_dotenv()
from fastapi import FastAPI 
from config.model import pipe, tokenizer, model
from routes import users, chats

# Load environment variables (if any)

# Create the FastAPI app
app = FastAPI()

# Include routers
app.include_router(users.router, prefix="/users")
app.include_router(chats.router, prefix="/chats")
