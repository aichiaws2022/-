#--------------------------------------
# EFSの作成
#----------------------------------------

resource "aws_efs_file_system" "wp-test-EFS" {

  encrypted = "true"
  tags = {
    Name = "${var.project}-${var.environment}-EFS"
  }
}

#マウントターゲットの作成
//マウントターゲット1a
resource "aws_efs_mount_target" "EFS-1a" {
  file_system_id  = aws_efs_file_system.wp-test-EFS.id
  subnet_id       = aws_subnet.public_subnet_1a.id
  security_groups = [aws_security_group.wp-EFS-sg.id]
}

//マウントターゲット1c
resource "aws_efs_mount_target" "EFS-1c" {
  file_system_id  = aws_efs_file_system.wp-test-EFS.id
  subnet_id       = aws_subnet.public_subnet_1c.id
  security_groups = [aws_security_group.wp-EFS-sg.id]
}

#--------------------------------------
# EFS-sgの作成
#----------------------------------------
resource "aws_security_group" "wp-EFS-sg" {
  name = "EFS-sg"

  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    //ec2セキュリティグループが紐づくリソースにアクセス許可
    security_groups = [aws_security_group.ec2_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-EFS-sg"
  }
}