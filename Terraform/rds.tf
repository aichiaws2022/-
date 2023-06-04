#----------------------------------------
# RDSの構築
#----------------------------------------

# サブネットグループの作成
resource "aws_db_subnet_group" "rds-dbsubnet" {
  name       = "rds-dbsubnet"
  subnet_ids = [aws_subnet.private_subnet_2-1a.id, aws_subnet.private_subnet_2-1c.id]

  tags = {
    Name = "rds-dbsubnet"
  }
}



#RDSの作成
resource "aws_db_instance" "RDS" {
  identifier             = "dbwp"
  name                   = "wordpress"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.32"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = random_string.db_passwrod.result
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.rds-dbsubnet.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]

  storage_encrypted = true

  //バックアップを保持する日数
  backup_retention_period = 0

  //DB削除前にスナップショットを作成しない
  skip_final_snapshot = true

  tags = {
    name = "${var.project}-${var.environment}-rds"
  }
}



resource "random_string" "db_passwrod" {
  length  = 10
  special = false
}

resource "aws_security_group" "rds-sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-sg"
  }
}