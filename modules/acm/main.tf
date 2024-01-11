# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate
# TODO: add ssl cert to AWS ACM for domain
data "aws_acm_certificate" "ssl" {
  domain   = var.domain
  statuses = ["ISSUED"]
}
