terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.32.0"
    }
  }
}

variable "dns_zone_id" {}
variable "dns_name_us" {}
variable "dns_name_eu" {}

// US
module "us-east-1" {
  source      = "./module"
  region      = "us-east-1"
  region_abbr = "US"
  dns_zone_id = "${var.dns_zone_id}"
  dns_name    = "${var.dns_name_us}"
}

// Europe
module "eu-central-1" {
  source      = "./module"
  region      = "eu-central-1"
  region_abbr = "EU"
  dns_zone_id = "${var.dns_zone_id}"
  dns_name    = "${var.dns_name_eu}"
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = "${var.dns_name_eu}"
    origin_id   = "${var.dns_name_eu}"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled = true

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "${var.dns_name_eu}"
    cache_policy_id          = "${aws_cloudfront_cache_policy.no_cache_policy.id}"
    origin_request_policy_id = "${aws_cloudfront_origin_request_policy.region_policy.id}"
    viewer_protocol_policy   = "allow-all"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_request_policy" "region_policy" {
  name = "region-policy"

  cookies_config {
    cookie_behavior = "whitelist"
    cookies {
      items = ["region"]
    }
  }

  headers_config {
    header_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "whitelist"
    query_strings {
      items = ["region"]
    }
  }
}

resource "aws_cloudfront_cache_policy" "no_cache_policy" {
  name        = "no-cache-policy"
  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}