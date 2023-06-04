# ---------------
# acm.tf
# ---------------

resource "aws_acm_certificate" "acm_cert" {
  domain_name       = var.root_domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_cert" {
  for_each = {
    for dvo in aws_acm_certificate.acm_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = aws_route53_zone.site_zone.zone_id
}

resource "aws_acm_certificate_validation" "acm_cert" {
  certificate_arn         = aws_acm_certificate.acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_cert : record.fqdn]
}

# HTTPSにリスナー設定
resource "aws_lb_listener" "https-listener" {
  load_balancer_arn = aws_lb.WP-ALB.arn
  port              = "443"
  protocol          = "HTTPS"
  //SSLのバージョン指定
  ssl_policy = "ELBSecurityPolicy-2016-08"
  //ACM証明書をHTTPSリスナーに関連づけ
  certificate_arn = aws_acm_certificate.acm_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WP-TGN.arn
  }
  depends_on = [
    aws_acm_certificate_validation.acm_cert
  ]

}