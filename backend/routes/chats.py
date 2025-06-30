from config.model import pipe, tokenizer, model
from fastapi import APIRouter
from config.db import database
import time
from pydantic import BaseModel

router = APIRouter()

class QueryInput(BaseModel):
    query: str

@router.post("/{id}/answer")
async def answer(id: str, input: QueryInput):
    """Generate a response to the user's query using the model."""
    
    
    query = input.query  


    chats = database.get_collection("chats")
    chat = chats.find_one({"id": id}, {'_id': 0})

    if not chat:
        return {"error": "Chat not found"}

    history = chat.get("messages", [])

    # Append the new user message to the history
    full_context = history + [{"role": "user", "content": query}]

    # Tokenize as LLaMA 3 chat messages
    formatted_input = tokenizer.apply_chat_template(full_context, tokenize=False, add_generation_prompt=True)
    inputs = tokenizer(formatted_input, return_tensors="pt")

    # Generate model response
    outputs = model.generate(inputs["input_ids"], max_new_tokens=200, do_sample=True)
    reply = tokenizer.decode(outputs[0], skip_special_tokens=True)

    # Remove the user's query from the chat template portion
    reply = reply.split(query)[-1].strip()

    # Append assistant reply to the conversation history
    updated_history = full_context + [{"role": "assistant", "content": reply}]

    # Update the chat document
    chats.update_one(
        {"id": id},
        {
            "$set": {
                "messages": updated_history,
                "updateDate": time.time(),
            }
        }
    )

    return {"response": reply}



@router.get("/{id}")
async def getChatById(id: str):
    """Fetch a chat by its ID."""
   
    chat = database.get_collection("chats").find_one({"id": id}, {'_id': 0})
    return chat
