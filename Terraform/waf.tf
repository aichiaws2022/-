resource "aws_wafv2_web_acl" "wordpress-waf" {
  name        = "managed-rule-Wordpress"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule1"
    priority = 0

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesWordPressRuleSet"
        vendor_name = "AWS"

        }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "wordpress-metric"
      sampled_requests_enabled   = true
    }
  }

    visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "wordpress-metric"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "association" {
  resource_arn = aws_lb.WP-ALB.arn
  web_acl_arn  = aws_wafv2_web_acl.wordpress-waf.arn
}