# ---------------------------------------------
# Subnet
# ---------------------------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "private_subnet_1-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.12.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-2"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_2-1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.21.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-3"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_2-1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.22.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-4"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

# ---------------------------------------------
# Route Table
# ---------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_subnet_2-1a-rt" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_2-1a.id
}

resource "aws_route_table_association" "private_subnet_2-1c-rt" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_2-1c.id
}

# ---------------------------------------------
# Internet Gateway
# ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "public_rt_igw_" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# ---------------------------------------------
# Nat Gateway
# ---------------------------------------------
resource "aws_eip" "nat_1a_eip" {
  vpc = true

  tags = {
    Name = "${var.project}-${var.environment}-eip"
  }
}
resource "aws_nat_gateway" "nat_1a" {
  subnet_id     = aws_subnet.public_subnet_1a.id # NAT Gatewayを配置するSubnetを指定
  allocation_id = aws_eip.nat_1a_eip.id          # 紐付けるElasti IP

  tags = {
    Name = "${var.project}-${var.environment}-ngw"
  }
}

resource "aws_route_table" "private-nat-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1a.id
  }

  tags = {
    Name = "private_subnet_route_table"
  }
}

resource "aws_route_table_association" "private-association1" {
  route_table_id = aws_route_table.private-nat-rt.id
  subnet_id      = aws_subnet.private_subnet_1-1a.id
}

resource "aws_route_table_association" "private-association2" {
  route_table_id = aws_route_table.private-nat-rt.id
  subnet_id      = aws_subnet.private_subnet_1-1c.id
}