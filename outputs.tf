output "trusted_signers" {
  description = "The key pair IDs that CloudFront is aware of for each trusted signer, if the distribution is set up to serve private content with signed URLs."
  value       = local.trusted_signers[0]
}

output "arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value = element(
    coalescelist(
      aws_cloudfront_distribution.cf_distribution.*.arn,
      aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.arn,
      [""],
    ),
    0,
  )
}

output "caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value = element(
    coalescelist(
      aws_cloudfront_distribution.cf_distribution.*.caller_reference,
      aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.caller_reference,
      [""],
    ),
    0,
  )
}

output "domain_name" {
  description = "The domain name corresponding to the distribution."
  value = element(
    coalescelist(
      aws_cloudfront_distribution.cf_distribution.*.domain_name,
      aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.domain_name,
      [""],
    ),
    0,
  )
}

output "etag" {
  description = "The current version of the distribution's information."
  value = element(
    coalescelist(
      aws_cloudfront_distribution.cf_distribution.*.etag,
      aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.etag,
      [""],
    ),
    0,
  )
}

output "hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value = element(
    coalescelist(
      aws_cloudfront_distribution.cf_distribution.*.hosted_zone_id,
      aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.hosted_zone_id,
      [""],
    ),
    0,
  )
}

output "id" {
  description = "The identifier for the distribution."
  value = element(
    coalescelist(
      aws_cloudfront_distribution.cf_distribution.*.id,
      aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.id,
      [""],
    ),
    0,
  )
}

output "in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value = element(
    coalescelist(
      aws_cloudfront_distribution.cf_distribution.*.in_progress_validation_batches,
      aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.in_progress_validation_batches,
      [""],
    ),
    0,
  )
}

output "last_modified_time" {
  description = "The date and time the distribution was last modified."
  value = element(
    coalescelist(
      aws_cloudfront_distribution.cf_distribution.*.last_modified_time,
      aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.last_modified_time,
    ),
    0,
  )
}

output "status" {
  description = "The current status of the distribution."
  value = element(
    coalescelist(
      aws_cloudfront_distribution.cf_distribution.*.status,
      aws_cloudfront_distribution.cf_distribution_no_s3_origin_config.*.status,
      [""],
    ),
    0,
  )
}
