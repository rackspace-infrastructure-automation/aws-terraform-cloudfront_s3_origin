/**
 * # aws-terraform-cloudfront_s3_origin
 *
 * This modules creates an AWS CloudFront distribution with S3 origin
 * Enable Logging
 * If you enable logging the bucket must already exist. You will get an error if you try
 * to use a dynamic bucket like "${aws_s3_bucket.cloudfront_log_s3bucket.bucket_domain_name}"
 * You must use something like bucket = "MyExistingbucket"
 *
 * ## Basic Usage
 *
 * ```
 * module "cloudfront_s3_origin" {
 *   source              = "git@github.com:rackspace-infrastructure-automation/aws-terraform-cloudfront_s3_origin//?ref=v0.0.3"
 *   domain_name         = "${aws_s3_bucket.cloudfront_s3bucket.bucket_regional_domain_name}"
 *   origin_id           = "${random_string.cloudfront_rstring.result}"
 *   enabled             = true
 *   comment             = "This is a test comment"
 *   default_root_object = "index.html"
 *
 *   # logging config
 *   # Bucket must already exist, can't be generated as a resource along with example.
 *   # This is a TF bug.
 *   # The bucket name must be the full bucket ie bucket.s3.amazonaws.com
 *   bucket = "mybucket.s3.amazonaws.com"
 *
 *   prefix         = "myprefix"
 *   bucket_logging = true
 *
 *   aliases = ["testdomain.testing.example.com"]
 *
 *   # Origin access id
 *   origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
 *
 *   # default cache behavior
 *   allowed_methods  = ["GET", "HEAD"]
 *   cached_methods   = ["GET", "HEAD"]
 *   path_pattern     = "*"
 *   target_origin_id = "${random_string.cloudfront_rstring.result}"
 *
 *   # Forwarded Values
 *   query_string = false
 *
 *   #Cookies
 *   forward = "none"
 *
 *   viewer_protocol_policy = "redirect-to-https"
 *   default_ttl            = "3600"
 *
 *   price_class = "PriceClass_200"
 *
 *   # restrictions
 *   restriction_type = "whitelist"
 *   locations        = ["US", "CA", "GB", "DE"]
 *
 *   # Certificate
 *   cloudfront_default_certificate = true
 * }
 *```
 *
 * Full working references are available at [examples](examples)
 */

terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.1.0"
  }
}

locals {
  tags = {
    Name            = var.origin_id
    ServiceProvider = "Rackspace"
    Environment     = var.environment
  }

  bucket_logging = {
    enabled = [
      {
        bucket          = var.bucket
        include_cookies = var.include_cookies
        prefix          = var.prefix
      },
    ]
    disabled = []
  }

  bucket_logging_config = var.bucket_logging ? "enabled" : "disabled"

  active_trusted_signers = coalescelist(
    aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.active_trusted_signers,
    aws_cloudfront_distribution.cf_distribution.*.active_trusted_signers,
    [""],
  )
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  count   = var.origin_access_identity_provided ? 1 : 0
  aliases = var.aliases

  default_cache_behavior {
    allowed_methods = var.allowed_methods
    cached_methods  = var.cached_methods
    compress        = var.compress
    default_ttl     = var.default_ttl

    forwarded_values {
      cookies {
        forward           = var.forward
        whitelisted_names = var.whitelisted_names
      }

      headers                 = var.headers
      query_string            = var.query_string
      query_string_cache_keys = var.query_string_cache_keys
    }

    # Removing this property due to issues dynamically providing these values.  Will be reenabled
    # after release of terraform v0.12 and support for dynamic config blocks.
    #
    # lambda_function_association = "${var.lambdas}"

    max_ttl                = var.max_ttl
    min_ttl                = var.min_ttl
    smooth_streaming       = var.smooth_streaming
    target_origin_id       = var.target_origin_id
    trusted_signers        = var.trusted_signers
    viewer_protocol_policy = var.viewer_protocol_policy
  }

  comment             = var.comment
  default_root_object = var.default_root_object
  enabled             = var.enabled
  http_version        = var.http_version
  is_ipv6_enabled     = var.is_ipv6_enabled

  dynamic "logging_config" {
    for_each = local.bucket_logging[local.bucket_logging_config]
    content {
      bucket          = logging_config.value.bucket
      include_cookies = lookup(logging_config.value, "include_cookies", null)
      prefix          = lookup(logging_config.value, "prefix", null)
    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }

  origin {
    domain_name = var.domain_name
    dynamic "custom_header" {
      for_each = var.custom_header
      content {
        name  = custom_header.value.name
        value = custom_header.value.value
      }
    }
    origin_id   = var.origin_id
    origin_path = var.origin_path

    s3_origin_config {
      origin_access_identity = var.origin_access_identity
    }
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      locations        = var.locations
      restriction_type = var.restriction_type
    }
  }

  tags = merge(var.tags, local.tags)

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = var.cloudfront_default_certificate
    iam_certificate_id             = var.iam_certificate_id
    minimum_protocol_version       = var.minimum_protocol_version
    ssl_support_method             = var.ssl_support_method
  }

  web_acl_id = var.web_acl_id
}

resource "aws_cloudfront_distribution" "cf_distribution_no_s3_origin_config" {
  count   = var.origin_access_identity_provided ? 0 : 1
  aliases = var.aliases

  default_cache_behavior {
    allowed_methods = var.allowed_methods
    cached_methods  = var.cached_methods
    compress        = var.compress
    default_ttl     = var.default_ttl

    forwarded_values {
      cookies {
        forward           = var.forward
        whitelisted_names = var.whitelisted_names
      }

      headers                 = var.headers
      query_string            = var.query_string
      query_string_cache_keys = var.query_string_cache_keys
    }

    # Removing this property due to issues dynamically providing these values.  Will be reenabled
    # after release of terraform v0.12 and support for dynamic config blocks.
    #
    # lambda_function_association = "${var.lambdas}"

    max_ttl                = var.max_ttl
    min_ttl                = var.min_ttl
    smooth_streaming       = var.smooth_streaming
    target_origin_id       = var.target_origin_id
    trusted_signers        = var.trusted_signers
    viewer_protocol_policy = var.viewer_protocol_policy
  }

  comment             = var.comment
  default_root_object = var.default_root_object
  enabled             = var.enabled
  http_version        = var.http_version
  is_ipv6_enabled     = var.is_ipv6_enabled

  dynamic "logging_config" {
    for_each = local.bucket_logging[local.bucket_logging_config]
    content {
      bucket          = logging_config.value.bucket
      include_cookies = lookup(logging_config.value, "include_cookies", null)
      prefix          = lookup(logging_config.value, "prefix", null)
    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }

  origin {
    domain_name = var.domain_name
    dynamic "custom_header" {
      for_each = var.custom_header
      content {
        name  = custom_header.value.name
        value = custom_header.value.value
      }
    }
    origin_id   = var.origin_id
    origin_path = var.origin_path
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      locations        = var.locations
      restriction_type = var.restriction_type
    }
  }

  tags = merge(var.tags, local.tags)

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = var.cloudfront_default_certificate
    iam_certificate_id             = var.iam_certificate_id
    minimum_protocol_version       = var.minimum_protocol_version
    ssl_support_method             = var.ssl_support_method
  }

  web_acl_id = var.web_acl_id
}
