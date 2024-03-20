data "aws_iam_policy_document" "lambda_assum_role_policy"{
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {  
  name = "lambda-role-glue"  
  assume_role_policy = data.aws_iam_policy_document.lambda_assum_role_policy.json
}

# data "aws_iam_policy_document" "lambda_role_policy_document" {
#    statement {
#      effect = "Allow"

#      actions = [
#        "glue:StartJobRun"
#      ]

#      resources = [
#        "arn:aws:glue:*:053133541769:job/*"
#      ]
#    }
# }

data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "../lambda_function.py" 
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "example_lambda" {
  filename      = "lambda_function.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  function_name = "lambda_exec_glue"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
}