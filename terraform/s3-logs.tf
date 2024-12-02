resource "aws_s3_bucket" "s3-logs" {
  bucket        = "intern-s3-logs"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "name" {
    bucket = aws_s3_bucket.s3-logs.bucket
    acl    = "private"
    depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3-logs.bucket
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_lb_write" {
  bucket = aws_s3_bucket.s3-logs.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::127311923021:root"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.s3-logs.arn}/*"
    }
  ]
}
POLICY
}