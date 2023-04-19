# Introduction to MLOps with AWS SageMaker, running your first LLM - SECON 2023

## Getting Started

### Prerequisites - Runtimes

Install the following binaries installed on your machine:

```bash
brew install awscli
brew install go-task
brew install terraform
```

### Prerequisites - AWS Resources

1. Clone the repo
    ```bash
    git clone https://github.com/eschizoid/secon-2023.git
    ```
2. Run Terraform init to check the provider loaded as expected
   ```bash
   task tf_init
   ```
3. Run Terraform Plan
   ```bash
   task tf_plan
   ```
4. Run Terraform apply
   ```bash
   task tf_apply
   ```
5. Create Sagemaker domain, user profile and notebook instance
   ```bash
    task sm_create_studio
    ```

## Launching Jupyter Lab

### TODO: Add instructions to launch Jupyter Lab from AWS Console

## Deploy LLM - Flan T5 XXL

### TODO: Add instructions to deploy model using Jupyter notebook

## Consuming SageMaker Endpoint

![](images/flan-t5-xxl-playground.png)

Inspired by the documentation on how to
use [TensorBoard in SM Studio](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-tensorboard.html), we can use the
same mechanism to spin up a [Streamlit](https://streamlit.io) app in SM Studio.

To do so, just execute the following command:

```bash
task run_playground
```

You will be able to access the playground
on `https://<YOUR_STUDIO_ID>.studio.<YOUR_REGION>.sagemaker.aws/jupyter/default/proxy/6006/`.
