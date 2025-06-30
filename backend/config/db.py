
from pymongo import MongoClient
import os


print("Connecting to MongoDB...")

client = MongoClient(os.getenv("MONGO_URI"))

database = client.get_database(os.getenv("MONGO_DB_NAME"))

