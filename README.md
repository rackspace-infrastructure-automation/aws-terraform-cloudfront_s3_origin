# aws-terraform-cloudfront\_s3\_origin

This modules creates an AWS CloudFront distribution with S3 origin
### Enable Logging  
If you enable logging the bucket must already exist. You will get an error if you try  
to use a dynamic bucket like `"${aws_s3_bucket.cloudfront_log_s3bucket.bucket_domain_name}"`.  
You must use something like `bucket = "MyExistingbucket"`.

## Basic Usage

```
module "cloudfront_s3_origin" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-cloudfront_s3_origin//?ref=v0.12.1"

  allowed_methods                 = ["GET", "HEAD"]
  bucket_logging                  = false
  cached_methods                  = ["GET", "HEAD"]
  cloudfront_default_certificate  = true
  comment                         = "This is a test comment"
  default_root_object             = "index.html"
  default_ttl                     = 3600
  domain_name                     = aws_s3_bucket.cloudfront_s3bucket.bucket_regional_domain_name
  enabled                         = true
  forward                         = "none"
  locations                       = ["US", "CA", "GB", "DE"]
  origin_access_identity          = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
  origin_access_identity_provided = true
  origin_id                       = random_string.cloudfront_rstring.result
  path_pattern                    = "*"
  price_class                     = "PriceClass_200"
  query_string                    = false
  restriction_type                = "whitelist"
  target_origin_id                = random_string.cloudfront_rstring.result
  viewer_protocol_policy          = "redirect-to-https"

  custom_error_response = [
    {
      error_code            = 404
      error_caching_min_ttl = 30
    },
    {
      error_code            = 403
      error_caching_min_ttl = 30
      response_code         = 200
      response_page_path    = "/error_page.html"
    },
  ]
}
```

Full working references are available at [examples](examples)

## Terraform 0.12 upgrade

Several changes were made while adding terraform 0.12 compatibility.  
The main change to be aware of is the `customer_header` variable  
changed types from `list(string)` to `list(map(string))` to properly function with dynamic  
configuration blocks.

## AWS Provider 3.0 upgrade

Due to the property renaming, `active_trusted_signers` is now `trusted_signers` and the  
underlying property is an attribute driven map instead of the original list format

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| acm\_certificate\_arn | The ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. Specify this, cloudfront\_default\_certificate, or iam\_certificate\_id. The ACM certificate must be in US-EAST-1. | `string` | `""` | no |
| aliases | Extra CNAMEs (alternate domain names), if any, for this distribution. (OPTIONAL) | `list(string)` | `[]` | no |
| allowed\_methods | HTTP methods that CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Allowed values are: ["HEAD", "GET"], ["GET", "HEAD", "OPTIONS"], or ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]. | `list(string)` | <pre>[<br>  "HEAD",<br>  "GET"<br>]</pre> | no |
| bucket | The Amazon S3 bucket address where access logs are stored | `string` | `""` | no |
| bucket\_logging | Enable logging to an S3 Bucket. If this is set you must configure below. | `bool` | `false` | no |
| cached\_methods | HTTP methods for which CloudFront caches responses. Allowed values are: ["HEAD", "GET"] or ["GET", "HEAD", "OPTIONS"]. | `list(string)` | <pre>[<br>  "HEAD",<br>  "GET"<br>]</pre> | no |
| cloudfront\_default\_certificate | if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. Specify this, acm\_certificate\_arn, or iam\_certificate\_id. | `string` | `""` | no |
| comment | Any comments you want to include about the distribution. (OPTIONAL) | `string` | `""` | no |
| compress | Indicates whether CloudFront automatically compresses certain files for this cache behavior. (OPTIONAL) | `bool` | `false` | no |
| custom\_error\_response | (Optional) - List of one or more custom error response element maps | `list(map(string))` | `[]` | no |
| custom\_header | One or more sub-resources with name and value parameters that specify header data that will be sent to the origin. For example: `[{name = "header1", value = "value1"}]`. | `list(map(string))` | `[]` | no |
| default\_root\_object | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | `string` | `""` | no |
| default\_ttl | The default time in seconds that objects stay in CloudFront caches before CloudFront forwards another request to your custom origin to determine whether the object has been updated. | `number` | `3600` | no |
| domain\_name | The DNS domain name of either the S3 bucket, or web site of your custom origin. | `string` | `""` | no |
| enabled | Whether the distribution is enabled to accept end user requests for content. | `bool` | `true` | no |
| environment | A field used to set the Environment tag on created resources | `string` | `"Development"` | no |
| forward | pecifies whether you want CloudFront to forward cookies to the origin that is associated with this cache behavior. You can specify all, none or whitelist. If whitelist, you must include the subsequent whitelisted\_names | `string` | `"all"` | no |
| headers | Specifies the headers that you want Amazon CloudFront to forward to the origin for this cache behavior. (OPTIONAL) | `list(string)` | `[]` | no |
| http\_version | The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2. | `string` | `"http2"` | no |
| iam\_certificate\_id | The IAM certificate identifier of the custom viewer certificate for this distribution if you are using a custom domain. Specify this, acm\_certificate\_arn, or cloudfront\_default\_certificate. | `string` | `""` | no |
| include\_cookies | Indicates whether CloudFront includes cookies in access logs. | `bool` | `false` | no |
| is\_ipv6\_enabled | Whether the IPv6 is enabled for the distribution. (OPTIONAL) | `bool` | `false` | no |
| locations | The two-letter, uppercase country code for a country that you want to include in your blacklist or whitelist. | `list(string)` | `[]` | no |
| max\_ttl | The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. (OPTIONAL) | `number` | `86400` | no |
| min\_ttl | The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. (OPTIONAL) | `number` | `0` | no |
| minimum\_protocol\_version | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. See https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#minimum_protocol_version | `string` | `"TLSv1.2_2018"` | no |
| ordered\_cache\_behavior | An ordered list of cache behaviors resource for this distribution. (OPTIONAL) | `list(string)` | `[]` | no |
| origin\_access\_identity | The CloudFront origin access identity to associate with the origin. You must specify the full origin ID | `string` | `""` | no |
| origin\_access\_identity\_provided | origin\_access\_identity has been provided | `bool` | `false` | no |
| origin\_id | An identifier for the origin. The value of Id must be unique within the distribution. | `string` | n/a | yes |
| origin\_path | The path that CloudFront uses to request content from an S3 bucket or custom origin. The combination of the DomainName and OriginPath properties must resolve to a valid path. The value must start with a slash mark (/) and cannot end with a slash mark. (OPTIONAL) | `string` | `""` | no |
| path\_pattern | The pattern to which an ordered cache behavior applies. | `string` | n/a | yes |
| prefix | Indicates whether CloudFront includes cookies in access logs. | `string` | `""` | no |
| price\_class | The price class for this distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100. | `string` | `"PriceClass_All"` | no |
| query\_string | Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior. | `bool` | `false` | no |
| query\_string\_cache\_keys | When specified, along with a value of true for query\_string, all query strings are forwarded, however only the query string keys listed in this argument are cached. When omitted with a value of true for query\_string, all query string keys are cached. (OPTIONAL) | `list(string)` | `[]` | no |
| restriction\_type | The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist. | `string` | `""` | no |
| smooth\_streaming | Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior. (OPTIONAL) | `bool` | `false` | no |
| ssl\_support\_method | Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only. Required if you specify acm\_certificate\_arn or iam\_certificate\_id. NOTE: vip causes CloudFront to use a dedicated IP address and may incur extra charges. | `string` | `"sni-only"` | no |
| tags | A mapping of tags applied to resources created by the module | `map(string)` | `{}` | no |
| target\_origin\_id | The ID value of the origin to which you want CloudFront to route requests when a request matches the value of the PathPattern property. | `string` | n/a | yes |
| trusted\_signers | he AWS accounts, if any, that you want to allow to create signed URLs for private content. (OPTIONAL) | `list(string)` | `[]` | no |
| viewer\_protocol\_policy | the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https. | `string` | n/a | yes |
| web\_acl\_id | The AWS WAF web ACL to associate with this distribution. | `string` | `""` | no |
| whitelisted\_names | If you have specified whitelist to forward, the whitelisted cookies that you want. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN (Amazon Resource Name) for the distribution. |
| caller\_reference | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| domain\_name | The domain name corresponding to the distribution. |
| etag | The current version of the distribution's information. |
| hosted\_zone\_id | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| id | The identifier for the distribution. |
| in\_progress\_validation\_batches | The number of invalidation batches currently in progress. |
| last\_modified\_time | The date and time the distribution was last modified. |
| status | The current status of the distribution. |
| trusted\_signers | The key pair IDs that CloudFront is aware of for each trusted signer, if the distribution is set up to serve private content with signed URLs. |

