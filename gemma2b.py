# model test gemma 7b with pytorch

import datetime
start_time = datetime.datetime.now()

import transformers

from transformers import AutoTokenizer, AutoModelForCausalLM

from huggingface_hub import login
login(token='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')

tokenizer = AutoTokenizer.from_pretrained("google/gemma-2b")

model = AutoModelForCausalLM.from_pretrained("google/gemma-2b", device_map="auto")

input_text = "Write me a poem about Machine Learning." 

input_ids = tokenizer(input_text, return_tensors="pt").to("cuda")

print('model generate')

outputs = model.generate(**input_ids, max_new_tokens=20)

print(tokenizer.decode(outputs[0])) 

end_time = datetime.datetime.now()
execution_time = end_time - start_time

print("Execution time:", execution_time, "seconds")