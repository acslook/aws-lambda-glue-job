resource "aws_s3_bucket_object" "file_upload" {
  bucket = var.S3_BUCKET_SCRIPT
  key    = "scripts/job_exemplo.py"
  source = "./script/job_exemplo.py"
  etag   = "${filemd5("./script/job_exemplo.py")}"
}

resource "aws_glue_job" "glue_example" {
  name     = "glue_etl_example"
  role_arn = "arn:aws:iam::053133541769:role/glue_acessando_s3"
  glue_version = "4.0"
  number_of_workers = 10
  tags = { teste = "teste" }
  worker_type = "G.1X"

  command {
    script_location = "s3://${var.S3_BUCKET_SCRIPT}/scripts/job_exemplo.py"
    python_version  = 3
  }
}