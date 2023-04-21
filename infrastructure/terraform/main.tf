data "aws_iam_policy_document" "sm_domain" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "sagemaker_domain_execution_role" {
  name               = "aws-sagemaker-domain-execution-iam-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sm_domain.json
}

resource "aws_iam_role_policy_attachment" "s3_full_access_role_policy_attach" {
  role       = aws_iam_role.sagemaker_domain_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker_full_access_role_policy-attach" {
  role       = aws_iam_role.sagemaker_domain_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker_canvas_full_access_role_policy_attach" {
  role       = aws_iam_role.sagemaker_domain_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerCanvasFullAccess"
}

resource "aws_sagemaker_image" "sagemaker_python38_image" {
  image_name = "sagemaker-python38"
  role_arn   = aws_iam_role.sagemaker_domain_execution_role.arn
}

resource "aws_sagemaker_image_version" "sagemaker_python38_image_version" {
  image_name = aws_sagemaker_image.sagemaker_python38_image.image_name
  base_image = "450285109346.dkr.ecr.us-east-1.amazonaws.com/python:3.8-bullseye"
}

resource "aws_sagemaker_app_image_config" "sagemaker_kernel_config" {
  app_image_config_name = "sagemaker-kernelgateway"
  kernel_gateway_image_config {
    kernel_spec {
      name = "kernel"
    }
  }
}

resource "aws_sagemaker_domain" "sagemaker_domain" {
  domain_name = var.sm_domain_name
  auth_mode   = "IAM"
  vpc_id      = var.sm_vpc_id
  subnet_ids  = var.sm_subnets
  default_user_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
    kernel_gateway_app_settings {
      custom_image {
        app_image_config_name = aws_sagemaker_app_image_config.sagemaker_kernel_config.app_image_config_name
        image_name            = aws_sagemaker_image_version.sagemaker_python38_image_version.image_name
      }
    }
  }
  default_space_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
  }
}

resource "aws_sagemaker_user_profile" "sagemaker_user_profile" {
  domain_id         = aws_sagemaker_domain.sagemaker_domain.id
  user_profile_name = var.sm_user_profile_name
  user_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
  }
}

resource "aws_sagemaker_app" "sagemaker_jupyter_server" {
  app_name          = "default"
  domain_id         = aws_sagemaker_domain.sagemaker_domain.id
  user_profile_name = aws_sagemaker_user_profile.sagemaker_user_profile.user_profile_name
  app_type          = "JupyterServer"
}

resource "aws_sagemaker_app" "sagemaker_kernel_gateway" {
  app_name          = "kernel"
  domain_id         = aws_sagemaker_domain.sagemaker_domain.id
  user_profile_name = aws_sagemaker_user_profile.sagemaker_user_profile.user_profile_name
  app_type          = "KernelGateway"
  resource_spec {
    instance_type       = "ml.t3.medium"
    sagemaker_image_arn = "arn:aws:sagemaker:us-east-1:450285109346:image-version/sagemaker-python38"
  }
}
