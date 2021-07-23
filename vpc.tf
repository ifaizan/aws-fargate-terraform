resource "aws_vpc" "VPC_created_by_terraform" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "CustomVPCbyTerraform"
  }
}

resource "aws_subnet" "main_public_1" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.VPC_created_by_terraform.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "main-public-1-terraform"
  }
}

resource "aws_subnet" "main_public_2" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.VPC_created_by_terraform.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "main-public-2-terraform"
  }
}

resource "aws_subnet" "main_private_1" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.VPC_created_by_terraform.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "main-private-1-terraform"
  }
}

resource "aws_subnet" "main_private_2" {
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.VPC_created_by_terraform.id
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "main-private-2-terraform"
  }
}

resource "aws_internet_gateway" "custom_vpc_igw" {
  vpc_id = aws_vpc.VPC_created_by_terraform.id

  tags = {
    Name = "custom-vpc-igw-terraform"
  }
}

resource "aws_route_table" "custom_rt_public" {
  vpc_id = aws_vpc.VPC_created_by_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_vpc_igw.id
  }

  tags = {
    Name = "custom-rt-public-terraform"
  }
}

resource "aws_route_table_association" "public_association-1" {
  subnet_id      = aws_subnet.main_public_1.id
  route_table_id = aws_route_table.custom_rt_public.id
}

resource "aws_route_table_association" "public_association-2" {
  subnet_id      = aws_subnet.main_public_2.id
  route_table_id = aws_route_table.custom_rt_public.id
}

resource "aws_eip" "ngw-eip" {
  vpc = true

  tags = {
    Name = "EPI-for-custom-vpc-ngw"
  }
}

resource "aws_nat_gateway" "custom_vpc_ngw" {
  subnet_id         = aws_subnet.main_public_1.id
  connectivity_type = "public"
  allocation_id     = aws_eip.ngw-eip.id

  tags = {
    Name = "custom-vpc-ngw-terraform"
  }
}

resource "aws_route_table" "custom_rt_private" {
  vpc_id = aws_vpc.VPC_created_by_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.custom_vpc_ngw.id
  }

  tags = {
    Name = "custom-rt-private-terraform"
  }
}

resource "aws_route_table_association" "private_association-1" {
  subnet_id      = aws_subnet.main_private_1.id
  route_table_id = aws_route_table.custom_rt_private.id
}

resource "aws_route_table_association" "private_association-2" {
  subnet_id      = aws_subnet.main_private_2.id
  route_table_id = aws_route_table.custom_rt_private.id
}