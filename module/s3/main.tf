# This IAM policy document allows the Amazon S3 service to assume a role for specific actions.
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["s3.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# Create replication s3 bucket
# resource "aws_iam_role" "replication" {
#   name               = var.aws_iam_role_rplication_name
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# data "aws_iam_policy_document" "replication" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:GetReplicationConfiguration",
#       "s3:ListBucket",
#     ]

#     resources = [aws_s3_bucket.source.arn]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:GetObjectVersionForReplication",
#       "s3:GetObjectVersionAcl",
#       "s3:GetObjectVersionTagging",
#     ]

#     resources = ["${aws_s3_bucket.source.arn}/*"]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:ReplicateObject",
#       "s3:ReplicateDelete",
#       "s3:ReplicateTags",
#     ]

#     resources = ["${aws_s3_bucket.destination.arn}/*"]
#   }
# }

# Create aws_iam_policy
# resource "aws_iam_policy" "replication_policy" {
#   name   = var.aws_iam_policy_replication_name
#   policy = data.aws_iam_policy_document.replication.json
# }

# Attach the replication policy to the IAM role
# resource "aws_iam_role_policy_attachment" "replication" {
#   role       = aws_iam_role.replication.name
#   policy_arn = aws_iam_policy.replication_policy.arn
# }

# Create destination S3 bucket
# resource "aws_s3_bucket" "destination" {
#   bucket = var.destination_bucket
# }

# Enable versioning for destination S3 bucket
# resource "aws_s3_bucket_versioning" "destination" {
#   bucket = aws_s3_bucket.destination.id
#   versioning_configuration {
#     status = var.bucket_versioning
#   }
# }


# Create source S3 bucket
resource "aws_s3_bucket" "source" {
  bucket   = var.bucket
#   acl    = "private" 
  tags = {
    Name = var.tag_name
  }
}

# Enable versioning for source S3 bucket
# resource "aws_s3_bucket_versioning" "source" {
#   bucket = aws_s3_bucket.source.id
#   versioning_configuration {
#     status = var.bucket_versioning
#   }
# }

# Configure replication from source to destination bucket
# resource "aws_s3_bucket_replication_configuration" "replication" {
#   depends_on = [aws_s3_bucket_versioning.source]

#   role   = aws_iam_role.replication.arn
#   bucket = aws_s3_bucket.source.id

#   rule {
#     id = "all-objects-replication"

#     status = "Enabled"

#     destination {
#       bucket        = aws_s3_bucket.destination.arn
#       storage_class = var.storage_class
#     }
#   }
# }
# ##############################################
# # Define IAM policy document for log delivery
# data "aws_iam_policy_document" "log_delivery_policy" {
#   statement {
#     sid       = "S3PolicyStmt-DO-NOT-MODIFY-1707329585711"
#     effect    = "Allow"
#     actions   = ["s3:PutObject"]
#     resources = ["${aws_s3_bucket.log_bucket.arn}/*"]

#     principals {
#       type        = "Service"
#       identifiers = ["logging.s3.amazonaws.com"]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceAccount"
#       values   = ["640379854124"]
#     }
#   }
# }

# # Attach log delivery policy to log bucket
# resource "aws_s3_bucket_policy" "log_delivery_policy" {
#   bucket = aws_s3_bucket.log_bucket.id
#   policy = data.aws_iam_policy_document.log_delivery_policy.json
# }

# # Create log bucket
# resource "aws_s3_bucket" "log_bucket" {
#   bucket = var.log_bucket

  
# }

# # Configure logging for source bucket
# resource "aws_s3_bucket_logging" "example" {
#   bucket = aws_s3_bucket.source.id
#   target_bucket = aws_s3_bucket.log_bucket.id
#   target_prefix = ""

# }

# ############################################################


# # Define IAM policy document for source bucket
# data "aws_iam_policy_document" "bucket_policy" {
#   statement {
#     sid       = "DenyDeleteObject"
#     effect    = "Deny"
#     actions   = [
#       "s3:DeleteObject",
#       "s3:DeleteObjectVersion"
#       # "s3:ListBucket",
#       # "s3:HeadBucket"
#     ]
#     resources = ["${aws_s3_bucket.source.arn}/*"]
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#   }

#   statement {
#     sid       = "EnableServerAccessLogging"
#     effect    = "Allow"
#     actions   = ["s3:PutObject"]
#     resources = ["${aws_s3_bucket.source.arn}/AWSLogs/640379854124/*"]
#     principals {
#       type        = "Service"
#       identifiers = ["logging.s3.amazonaws.com"]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "s3:x-amz-acl"
#       values   = ["bucket-owner-full-control"]
#     }
#   }
# }

# # Attach source bucket policy
# resource "aws_s3_bucket_policy" "source_bucket_policy" {
#   bucket = aws_s3_bucket.source.id
#   policy = data.aws_iam_policy_document.bucket_policy.json
# }



