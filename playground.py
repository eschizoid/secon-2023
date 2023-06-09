import json

import boto3
import streamlit as st


def generate_text(input_prompt: str) -> str:
    payload = {
        "inputs": input_prompt,
        "min_length": min_length,
        "max_length": max_length,
        "temperature": temperature,
        "repetition_penalty": rep_penalty,
        "do_sample": temperature > 0,
    }

    response = sagemaker_runtime.invoke_endpoint(
        EndpointName=endpoint_name,
        ContentType="application/json",
        Body=json.dumps(payload)
    )

    result = json.loads(response["Body"].read().decode())
    return result[0]["generated_text"]


session = boto3.Session()
sagemaker_runtime = session.client("sagemaker-runtime", region_name=session.region_name)
endpoint_name = "dolly-v2-12b"

st.sidebar.title("Dolly-V2 Parameters")
stop_word = st.sidebar.text_input("Stop word")
min_length, max_length = st.sidebar.slider("Min/Max length", 0, 500, (0, 100))
temperature = st.sidebar.slider("Temperature", min_value=0.0, max_value=1.0, value=0.6)
rep_penalty = st.sidebar.slider("Repetition Penalty", min_value=0.9, max_value=1.2, value=1.0)

st.header("Dolly-v2-12B Playground")
prompt = st.text_area("Enter your prompt here:")

if st.button("Run"):
    generated_text = generate_text(prompt)
    if len(stop_word) > 0:
        generated_text = generated_text[:generated_text.rfind(stop_word)]
    st.write(generated_text)
