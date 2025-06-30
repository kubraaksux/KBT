
from transformers import pipeline, AutoTokenizer, AutoModelForCausalLM
import os

# Initialize the pipeline and model
pipe = pipeline("text-generation", model=os.getenv("MODEL_NAME"))
tokenizer = AutoTokenizer.from_pretrained(os.getenv("MODEL_NAME"))
model = AutoModelForCausalLM.from_pretrained(os.getenv("MODEL_NAME"))
