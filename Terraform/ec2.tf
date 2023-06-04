#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------
data "template_file" "script" {
  template = file("script.tpl")
  vars = {
    efs_id = aws_efs_file_system.wp-test-EFS.id
  }
}

resource "aws_instance" "wordpress_server1" {
  ami                         = "ami-052c9af0c988f8bbd"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_1-1a.id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  user_data                   = base64encode(data.template_file.script.rendered)


  depends_on = [
    aws_nat_gateway.nat_1a
  ]




  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id

  ]




  tags = {
    Name    = "${var.project}-${var.environment}-wp1-ec2"
    Project = var.project
    Env     = var.environment

  }
}

resource "aws_instance" "wordpress_server2" {
  ami                         = "ami-052c9af0c988f8bbd"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_1-1c.id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  user_data                   = base64encode(data.template_file.script.rendered)


  depends_on = [
    aws_nat_gateway.nat_1a
  ]




  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id

  ]




  tags = {
    Name    = "${var.project}-${var.environment}-wp2-ec2"
    Project = var.project
    Env     = var.environment

  }
}

####################
# EC2 Security Group
####################
resource "aws_security_group" "ec2_sg" {
  name   = "wp-ec2-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ALB-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-${var.environment}-sg"
    Project = var.project
    Env     = var.environment
  }
}



  