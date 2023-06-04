# ---------------
# route53.tf
# ---------------

resource "aws_route53_zone" "site_zone" {
  name = var.root_domain

  tags = {
    Name = "root_domain"
  }
}

resource "aws_route53_record" "site" {
  zone_id = aws_route53_zone.site_zone.zone_id
  name    = var.site_domain
  type    = "A"

  alias {
    name                   = aws_lb.WP-ALB.dns_name
    zone_id                = aws_lb.WP-ALB.zone_id
    evaluate_target_health = true
  }
}