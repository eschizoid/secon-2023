import torch
from transformers import pipeline


def model_fn(model_dir):
    instruct_pipeline = pipeline(
        model="databricks/dolly-v2-12b",
        torch_dtype=torch.bfloat16,
        trust_remote_code=True,
        device_map="auto",
        model_kwargs={"load_in_8bit": True},
    )

    return instruct_pipeline
