from config.db import database
from fastapi import APIRouter

router = APIRouter()

@router.get("/{id}")
async def getUser(id: str):
    user = database.get_collection("users").find_one({"id": id}, {'_id': 0})
    return user

@router.get("/")
async def getUsers():
    users = list(database.get_collection("users").find({}, {'_id': 0}))
    return users


@router.get("/{id}/chats")
async def getUserChats(id: str):
    chats = list(database.get_collection("chats").find({"userId": id}, {'_id': 0}))
    return chats