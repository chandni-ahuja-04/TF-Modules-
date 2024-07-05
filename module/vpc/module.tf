terraform {
required_providers {
  aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
}
}
provider "aws" {
  region = "us-east-1"
}
#vpc
resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "terraform_vpc"
  }
}

#subnets
resource "aws_subnet" "mypubsub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet_pu_1
  availability_zone = var.zone1

  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "mypubsub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet_pu_2
  availability_zone = var.zone2

  tags = {
    Name = "public2"
  }
}

resource "aws_subnet" "mypvtsub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet_pr_1
  availability_zone = var.zone1

  tags = {
    Name = "private1"
  }
}

resource "aws_subnet" "mypvtsub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet_pr_2
  availability_zone = var.zone2

  tags = {
    Name = "private2"
  }
}

#internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myigw"
  }
}

#elastic_ip
resource "aws_eip" "myeip" {
  tags = {
    Name = "my-eip"
  } 
}

#nat_gateway
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.mypubsub1.id

  tags = {
    Name = "my-nat-gw"
  }
}

#route_tables
resource "aws_route_table" "route1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "route2" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = var.route_cidr
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "private"
  }
}

#subnet_association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mypubsub1.id
  route_table_id = aws_route_table.route1.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.mypubsub2.id
  route_table_id = aws_route_table.route1.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.mypvtsub1.id
  route_table_id = aws_route_table.route2.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.mypvtsub2.id
  route_table_id = aws_route_table.route2.id
}