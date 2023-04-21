data "aws_iam_policy_document" "sagemaker_domain" {
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
  assume_role_policy = data.aws_iam_policy_document.sagemaker_domain.json
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

resource "aws_sagemaker_domain" "sagemaker_domain" {
  domain_name = var.sm_domain_name
  auth_mode   = "IAM"
  vpc_id      = var.sm_vpc_id
  subnet_ids  = var.sm_subnets
  default_user_settings {
    execution_role = aws_iam_role.sagemaker_domain_execution_role.arn
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
