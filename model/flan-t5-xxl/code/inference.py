from transformers import T5ForConditionalGeneration, AutoTokenizer


def model_fn(model_dir):
    model_name = "google/flan-t5-xxl"
    model = T5ForConditionalGeneration.from_pretrained(model_name,
                                                       load_in_8bit=True,
                                                       device_map="auto",
                                                       cache_dir="/tmp/model_cache/")
    tokenizer = AutoTokenizer.from_pretrained("google/flan-t5-xxl")

    return model, tokenizer


def predict_fn(data, model_and_tokenizer):
    model, tokenizer = model_and_tokenizer
    text = data.pop("inputs", data)

    inputs = tokenizer(text, return_tensors="pt").input_ids.to("cuda")
    outputs = model.generate(inputs, **data)

    return tokenizer.decode(outputs[0], skip_special_tokens=True)
