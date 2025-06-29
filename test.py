import torch
import transformers

class Llama3:
    def __init__(self, model_path):
        self.model_id = model_path

        # Load the model manually
        self.model = transformers.AutoModelForCausalLM.from_pretrained(self.model_id)

        # Use the model tokenizer
        self.tokenizer = transformers.AutoTokenizer.from_pretrained(self.model_id)

        # Check if eos_token_id is set, if not, assign it to a default value
        if self.tokenizer.eos_token_id is None:
            self.tokenizer.eos_token_id = self.tokenizer.pad_token_id  # You can use pad_token_id or any other token if eos_token_id is None

        # Use the model with the Hugging Face pipeline
        self.pipeline = transformers.pipeline(
            "text-generation",
            model=self.model,
            tokenizer=self.tokenizer,
            model_kwargs={"torch_dtype": torch.float16},
        )

        # Define terminators to know when to stop generation
        self.terminators = [self.tokenizer.eos_token_id]  # Use eos_token_id directly


    def get_response(self, query, message_history=[], max_tokens=1024, temperature=0.6, top_p=0.9):
    # Add the user query to the message history
        user_prompt = message_history + [{"role": "user", "content": query}]
        
        # Convert the prompt to a string if it's in tensor format
        prompt = self.pipeline.tokenizer.encode(
            self.pipeline.tokenizer.bos_token + str(user_prompt), return_tensors="pt"
        )
        
        # Ensure that the prompt passed to the pipeline is a string
        prompt_text = self.pipeline.tokenizer.decode(prompt[0], skip_special_tokens=True)

        # Generate the response from the model
        outputs = self.pipeline(
            prompt_text,  # Make sure this is passed as a string
            max_new_tokens=max_tokens,
            eos_token_id=self.terminators,
            do_sample=True,
            temperature=temperature,
            top_p=top_p,
        )

        # Extract the generated response (after removing the prompt part)
        response = outputs[0]["generated_text"][len(prompt):]

        # Return the response along with the updated conversation history
        return response, user_prompt + [{"role": "assistant", "content": response}]


    def chatbot(self, system_instructions=""):
        conversation = [{"role": "system", "content": system_instructions}]
        
        # Loop for interacting with the chatbot
        while True:
            user_input = input("User: ")
            
            if user_input.lower() in ["exit", "quit"]:
                print("Exiting the chatbot. Goodbye!")
                break  # Exit the loop when the user types 'exit' or 'quit'
            
            response, conversation = self.get_response(user_input, conversation)
            print(f"Assistant: {response}")

# Main section to create a chatbot instance and start it
if __name__ == "__main__":
    bot = Llama3("/Users/kub/meta-llama")  # Use the correct path to your model
    bot.chatbot()  # Start the chatbot interaction
