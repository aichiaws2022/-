#----------------------------------------
# ALBの構築
#----------------------------------------
//ALB
resource "aws_lb" "WP-ALB" {
  name               = "higa-ALB"
  internal           = false
  load_balancer_type = "application"
  //アプリケーションタイプのロードバランサーに対してのみ有効
  security_groups = [aws_security_group.ALB-sg.id]
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]
  ip_address_type = "ipv4"

  tags = {
    name = "${var.project}-${var.environment}-ALB"
  }
}

// ターゲットグループ
resource "aws_lb_target_group" "WP-TGN" {
  name             = "WP-TGN"
  target_type      = "instance"
  protocol_version = "HTTP1"
  port             = 80
  protocol         = "HTTP"
  vpc_id           = aws_vpc.vpc.id

  tags = {
    name = "${var.project}-${var.environment}-TGN"
  }

  health_check {
    interval            = 7
    path                = "/wp-includes/images/blank.gif"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200,301"
  }
}

// ターゲットグループにEC2インスタンスを登録
//EC2インスタンスに登録
resource "aws_lb_target_group_attachment" "target_ec2-1" {
  target_group_arn = aws_lb_target_group.WP-TGN.arn
  target_id        = aws_instance.wordpress_server1.id
}
resource "aws_lb_target_group_attachment" "target_ec2-2" {
  target_group_arn = aws_lb_target_group.WP-TGN.arn
  target_id        = aws_instance.wordpress_server2.id
}

// リスナー設定
resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.WP-ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WP-TGN.arn
  }
}


#--------------------------------------
# ALB-sgの作成
#----------------------------------------
resource "aws_security_group" "ALB-sg" {
  name        = "ALB-sg"
  description = "ALB-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

