# origin type name
locals {
  s3_origin_id = "myS3Origin"
  
}

# Define IAM policy document for S3 bucket access
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:*"]
    resources = ["${data.aws_s3_bucket.cdn_s3_bucket.arn}" , "${data.aws_s3_bucket.cdn_s3_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.aws_oci.iam_arn]
    }
  }
}


# Attach S3 bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = data.aws_s3_bucket.cdn_s3_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

#########################################################################################################

# Create CloudFront origin access identity 
resource "aws_cloudfront_origin_access_identity" "aws_oci" {
  comment = "OCI" 
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = data.aws_s3_bucket.cdn_s3_bucket.bucket_regional_domain_name
    # origin_access_control_id = aws_cloudfront_origin_access_identity.example.id
    origin_id                = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.aws_oci.cloudfront_access_identity_path
    }
  }

  enabled             = true
#   is_ipv6_enabled     = true
#   comment             = "Some comment"
#   default_root_object = "sayaji.png.jpg"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  # Cache behavior with precedence 0
#   ordered_cache_behavior {
#     path_pattern     = "/content/immutable/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id = local.s3_origin_id

#     forwarded_values {
#       query_string = false
#       headers      = ["Origin"]

#       cookies {
#         forward = "none"
#       }
#     }

#     min_ttl                = 0
#     default_ttl            = 86400
#     max_ttl                = 31536000
#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"
#   }

#   # Cache behavior with precedence 1
#   ordered_cache_behavior {
#     path_pattern     = "/content/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.s3_origin_id

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }

#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"
#   }

#Use all edge locations (best performance)
  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    #   locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "cdn"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
