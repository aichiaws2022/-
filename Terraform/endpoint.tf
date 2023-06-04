
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.vpc.id
  subnet_ids        = [aws_subnet.private_subnet_1-1a.id]
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type = "Interface"


  security_group_ids = [
    aws_security_group.ssm.id
  ]

  private_dns_enabled = true

}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.vpc.id
  subnet_ids        = [aws_subnet.private_subnet_1-1a.id]
  service_name      = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type = "Interface"


  security_group_ids = [
    aws_security_group.ssm.id,
  ]

  private_dns_enabled = true

}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.vpc.id
  subnet_ids        = [aws_subnet.private_subnet_1-1a.id]
  service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type = "Interface"


  security_group_ids = [
    aws_security_group.ssm.id,
  ]

  private_dns_enabled = true

}



resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
  route_table_ids = [
    aws_route_table.private-nat-rt.id
  ]

}

####################
# VPC Endpoint Security Group
####################
resource "aws_security_group" "ssm" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_security_group_rule" "endpoint_ingress_https" {
  security_group_id = aws_security_group.ssm.id
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/16"]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}




