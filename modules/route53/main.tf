# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
data "aws_route53_zone" "hosted_zone" {
  name = var.domain
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    zone_id                = var.alb.zone_id
    name                   = var.alb.dns_name
    evaluate_target_health = true
  }
}
