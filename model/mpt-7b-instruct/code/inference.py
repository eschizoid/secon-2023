import torch
import transformers
from transformers import AutoTokenizer


def model_fn(model_dir):
    model_name = "mosaicml/mpt-7b-instruct"
    model = transformers.AutoModelForCausalLM.from_pretrained(
        model_name,
        torch_dtype=torch.bfloat16,
        trust_remote_code=True
    )
    model.to(device="cuda:0")

    tokenizer = AutoTokenizer.from_pretrained(model_name)

    return model, tokenizer


def predict_fn(data, model_and_tokenizer):
    model, tokenizer = model_and_tokenizer
    text = data.pop("inputs", data)

    inputs = tokenizer(text, return_tensors="pt").input_ids.to("cuda")
    outputs = model.generate(inputs, **data)

    return tokenizer.decode(outputs[0], skip_special_tokens=True)
