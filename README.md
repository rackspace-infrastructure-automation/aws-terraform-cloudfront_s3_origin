# aws-terraform-cloudfront_s3_origin

This modules creates an AWS CloudFront distribution with S3 origin

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm_certificate_arn | The ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. Specify this, cloudfront_default_certificate, or iam_certificate_id. The ACM certificate must be in US-EAST-1. | string | `` | no |
| aliases | Extra CNAMEs (alternate domain names), if any, for this distribution. (OPTIONAL) | list | `<list>` | no |
| allowed_methods | HTTP methods that CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Allowed values are: ["HEAD", "GET"], ["GET", "HEAD", "OPTIONS"], or ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]. | list | `<list>` | no |
| bucket | The Amazon S3 bucket address where access logs are stored | string | `` | no |
| bucket_logging | Enable logging to an S3 Bucket. If this is set you must configure below. | string | `false` | no |
| cached_methods | HTTP methods for which CloudFront caches responses. Allowed values are: ["HEAD", "GET"] or ["GET", "HEAD", "OPTIONS"]. | list | `<list>` | no |
| cloudfront_default_certificate | if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Specify this, acm_certificate_arn, or iam_certificate_id. | string | `` | no |
| comment | Any comments you want to include about the distribution. (OPTIONAL) | string | `` | no |
| compress | Indicates whether CloudFront automatically compresses certain files for this cache behavior. (OPTIONAL) | string | `false` | no |
| custom_header | One or more sub-resources with name and value parameters that specify header data that will be sent to the origin | list | `<list>` | no |
| default_root_object | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | string | `` | no |
| default_ttl | The default time in seconds that objects stay in CloudFront caches before CloudFront forwards another request to your custom origin to determine whether the object has been updated. | string | `3600` | no |
| domain_name | The DNS domain name of either the S3 bucket, or web site of your custom origin. | string | `` | no |
| enabled | Whether the distribution is enabled to accept end user requests for content. | string | `true` | no |
| environment | Application environment for which this is being created. one of: ('Development', 'Integration', 'PreProduction', 'Production', 'QA', 'Staging', 'Test') | string | `Development` | no |
| error_caching_min_ttl | (Optional) - The minimum amount of time you want HTTP error codes to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. | string | `` | no |
| error_code | (Required) - The 4xx or 5xx HTTP status code that you want to customize. | string | `` | no |
| forward | pecifies whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior. You can specify all, none or whitelist. If whitelist, you must include the subsequent whitelisted_names | string | `all` | no |
| headers | Specifies the headers that you want Amazon CloudFront to forward to the origin for this cache behavior. (OPTIONAL) | list | `<list>` | no |
| http_version | The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2. | string | `http2` | no |
| iam_certificate_id | The IAM certificate identifier of the custom viewer certificate for this distribution if you are using a custom domain. Specify this, acm_certificate_arn, or cloudfront_default_certificate. | string | `` | no |
| include_cookies | Indicates whether CloudFront includes cookies in access logs. | string | `false` | no |
| is_ipv6_enabled | Whether the IPv6 is enabled for the distribution. (OPTIONAL) | string | `false` | no |
| lambdas | A map of lambda functions and triggers. See https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_LambdaFunctionAssociation.html | list | `<list>` | no |
| locations | The two-letter, uppercase country code for a country that you want to include in your blacklist or whitelist. | list | `<list>` | no |
| max_ttl | The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. (OPTIONAL) | string | `86400` | no |
| min_ttl | The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. (OPTIONAL) | string | `0` | no |
| minimum_protocol_version | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. See https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#minimum_protocol_version | string | `TLSv1.2_2018` | no |
| ordered_cache_behavior | An ordered list of cache behaviors resource for this distribution. (OPTIONAL) | list | `<list>` | no |
| origin_access_identity | The CloudFront origin access identity to associate with the origin. You must specify the full origin ID | string | `` | no |
| origin_id | An identifier for the origin. The value of Id must be unique within the distribution. | string | - | yes |
| origin_path | The path that CloudFront uses to request content from an S3 bucket or custom origin. The combination of the DomainName and OriginPath properties must resolve to a valid path. The value must start with a slash mark (/) and cannot end with a slash mark. (OPTIONAL) | string | `` | no |
| path_pattern | The pattern to which an ordered cache behavior applies. | string | - | yes |
| prefix | Indicates whether CloudFront includes cookies in access logs. | string | `` | no |
| price_class | The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100. | string | `PriceClass_All` | no |
| query_string | Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior. | string | `false` | no |
| query_string_cache_keys | When specified, along with a value of true for query_string, all query strings are forwarded, however only the query string keys listed in this argument are cached. When omitted with a value of true for query_string, all query string keys are cached. (OPTIONAL) | list | `<list>` | no |
| response_code | (Optional) - The minimum amount of time you want HTTP error codes to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. | string | `` | no |
| response_page_path | (Optional) - The path of the custom error page (for example, /custom_404.html). | string | `` | no |
| restriction_type | The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist. | string | `` | no |
| smooth_streaming | Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior. (OPTIONAL) | string | `false` | no |
| ssl_support_method | Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only. Required if you specify acm_certificate_arn or iam_certificate_id. NOTE: vip causes CloudFront to use a dedicated IP address and may incur extra charges. | string | `sni-only` | no |
| tags | Custom tags to apply to all resources. | map | `<map>` | no |
| target_origin_id | The ID value of the origin to which you want CloudFront to route requests when a request matches the value of the PathPattern property. | string | - | yes |
| trusted_signers | he AWS accounts, if any, that you want to allow to create signed URLs for private content. (OPTIONAL) | list | `<list>` | no |
| viewer_protocol_policy | the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https. | string | - | yes |
| web_acl_id | The AWS WAF web ACL to associate with this distribution. | string | `` | no |
| whitelisted_names | If you have specified whitelist to forward, the whitelisted cookies that you want. | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| active_trusted_signers | The key pair IDs that CloudFront is aware of for each trusted signer, if the distribution is set up to serve private content with signed URLs. |
| arn | The ARN (Amazon Resource Name) for the distribution. |
| caller_reference | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| domain_name | The domain name corresponding to the distribution. |
| etag | The current version of the distribution's information. |
| hosted_zone_id | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| id | The identifier for the distribution. |
| in_progress_validation_batches | The number of invalidation batches currently in progress. |
| last_modified_time | The date and time the distribution was last modified. |
| status | The current status of the distribution. |
