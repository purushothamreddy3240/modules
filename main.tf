#Create vpc

resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = var.tags
}

# Create public subnet

resource "aws_subnet" "public" {
  count             = length(local.azs) 
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = local.azs[count.index]

  tags = {
    Name = "public-${count.index + 1}"
  }
}

# Create internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "main"
  }
}

# Craete Route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main"
  }
}

# Associate public subnets to public route table

resource "aws_route_table_association" "public" {  
  count          = length(local.azs) 
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}