# システムエラー時に通知と復旧を行うアラームを作成
//ec2-1のCWA
resource "aws_cloudwatch_metric_alarm" "CWA1" {
  alarm_name        = "CWA1"
  alarm_description = "EC2オートリカバリーのアラーム"
  metric_name       = "StatusCheckFailed_System"
  namespace         = "AWS/EC2"
  statistic         = "Maximum"
  //指定された統計値が比較される値
  period = "60"
  //指定された統計値が比較される値
  threshold           = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  dimensions = {
    InstanceId = aws_instance.wordpress_server1.id
  }
  //2回データポイントが越えた時アラーム状態にする
  evaluation_periods = "2"
  alarm_actions      = ["arn:aws:automate:ap-northeast-1:ec2:recover", "arn:aws:sns:ap-northeast-1:${data.aws_caller_identity.current.account_id}:WP-sns-topic"]
  treat_missing_data = "ignore"
  tags = {
    name = "${var.project}-${var.environment}-CWA1"
  }
}

resource "aws_cloudwatch_metric_alarm" "CWA2" {
  alarm_name        = "CWA1"
  alarm_description = "EC2オートリカバリーのアラーム"
  metric_name       = "CPUUtilization"
  namespace         = "AWS/EC2"
  statistic         = "Average"
  //指定された統計値が比較される値
  period = "60"
  //指定された統計値が比較される値
  threshold           = "80"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  dimensions = {
    InstanceId = aws_instance.wordpress_server1.id
  }
  //2回データポイントが越えた時アラーム状態にする
  evaluation_periods = "2"
  alarm_actions      = ["arn:aws:automate:ap-northeast-1:ec2:recover", "arn:aws:sns:ap-northeast-1:${data.aws_caller_identity.current.account_id}:WP-sns-topic"]
  treat_missing_data = "ignore"
  tags = {
    name = "${var.project}-${var.environment}-CWA2"
  }
}


resource "aws_cloudwatch_metric_alarm" "CWA3" {
  alarm_name        = "CWA3"
  alarm_description = "EC2オートリカバリーのアラーム"
  metric_name       = "StatusCheckFailed_System"
  namespace         = "AWS/EC2"
  statistic         = "Maximum"
  //指定された統計値が比較される値
  period = "60"
  //指定された統計値が比較される値
  threshold           = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  dimensions = {
    InstanceId = aws_instance.wordpress_server2.id
  }
  //2回データポイントが越えた時アラーム状態にする
  evaluation_periods = "2"
  alarm_actions      = ["arn:aws:automate:ap-northeast-1:ec2:recover", "arn:aws:sns:ap-northeast-1:${data.aws_caller_identity.current.account_id}:WP-sns-topic"]
  treat_missing_data = "ignore"
  tags = {
    name = "${var.project}-${var.environment}-CWA3"
  }
}

resource "aws_cloudwatch_metric_alarm" "CWA4" {
  alarm_name        = "CWA4"
  alarm_description = "EC2オートリカバリーのアラーム"
  metric_name       = "CPUUtilization"
  namespace         = "AWS/EC2"
  statistic         = "Average"
  //指定された統計値が比較される値
  period = "60"
  //指定された統計値が比較される値
  threshold           = "80"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  dimensions = {
    InstanceId = aws_instance.wordpress_server2.id
  }
  //2回データポイントが越えた時アラーム状態にする
  evaluation_periods = "2"
  alarm_actions      = ["arn:aws:automate:ap-northeast-1:ec2:recover", "arn:aws:sns:ap-northeast-1:${data.aws_caller_identity.current.account_id}:WP-sns-topic"]
  treat_missing_data = "ignore"
  tags = {
    name = "${var.project}-${var.environment}-CWA4"
  }
}

#ALB死活監視 EC2が正常かどうかを監視
resource "aws_cloudwatch_metric_alarm" "CWA7" {
  alarm_name        = "ALB-CWA"
  alarm_description = "ALB死活監視のアラーム"
  metric_name       = "HealthyHostCount"
  namespace         = "AWS/ApplicationELB"
  statistic         = "Minimum"
  //時間（秒）
  period = "60"
  //指定された統計値が比較される値
  threshold           = "1"
  comparison_operator = "LessThanOrEqualToThreshold"
  dimensions = {
    TargetGroup  = aws_lb_target_group.WP-TGN.arn_suffix
    LoadBalancer = aws_lb.WP-ALB.arn_suffix
  }
  //2回データポイントが越えた時アラーム状態にする
  evaluation_periods = "2"
  alarm_actions      = ["arn:aws:sns:ap-northeast-1:${data.aws_caller_identity.current.account_id}:WP-sns-topic"]
  treat_missing_data = "missing"
  tags = {
    name = "${var.project}-${var.environment}-CWA5"
  }
}

# 1.SNSトピック作成
resource "aws_sns_topic" "WP-sns-topic" {
  name = "${var.project}-${var.environment}-sns-topic"
}

# 2.サブスクリプション作成
resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.WP-sns-topic.arn
  protocol  = "email"
  endpoint  = var.email
}