# Definindo o provedor (AWS)
provider "aws" {
  region = "us-east-1"
}

# Bucket Creation
resource "aws_s3_bucket" "site_bucket" {
  bucket = "hackathon-fiap"
  acl = "public-read"
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

# Bucket Policy Setup
resource "aws_s3_bucket_policy" "site_bucket_policy" {
  bucket = aws_s3_bucket.site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.site_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Define default static url
output "site_url" {
  value = "http://${aws_s3_bucket.site_bucket.website_endpoint}"
}
