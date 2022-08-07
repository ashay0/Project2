#Creating VPC
resource "aws_vpc" "VPC" {
  cidr_block       = var.VPC_cidrBlock
  instance_tenancy = var.instanceTenancy
  enable_dns_hostnames = true

  tags = {
    Auther= var.vpcTags["Auther"]
    ENV   = var.vpcTags["ENV"]
    Name  = var.vpcTags["Name"]
  }
}


# Creating Subnet
resource "aws_subnet" "Subnet" {
  count = length(var.Subnet_cidrBlock)
  vpc_id     = aws_vpc.VPC.id
  cidr_block = element( var.Subnet_cidrBlock,  count.index  )
  availability_zone = element( var.availabilityZone , count.index )
  map_public_ip_on_launch = var.mapPublicIpOnLaunch

  tags = {
    Name = "${var.subnetTags["Name"]}-${count.index + 1}"
    ENV  = var.subnetTags["ENV"]
    Auther = var.subnetTags["Auther"]
  }
}


# Creating Internet Gateway
resource "aws_internet_gateway" "internetGateway" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = var.internetGatewayTags["Name"]
    Auther = var.internetGatewayTags["Auther"]
    ENV = var.internetGatewayTags["ENV"]
  }
}


# Creating Route Table
resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = var.routeTableTags["Name"]
    Auther = var.routeTableTags["Auther"]
    ENV = var.routeTableTags["ENV"]
  }
}


# Creating Routes for above Route Table
resource "aws_route" "Route" {
  route_table_id            = aws_route_table.routeTable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.internetGateway.id
}


# Associatiting the Route Table to the Subnet that created above
resource "aws_route_table_association" "routeTableAssociation" {
  count = length(var.Subnet_cidrBlock)
  subnet_id      = element(aws_subnet.Subnet.*.id, count.index)
  route_table_id = aws_route_table.routeTable.id
}


# Creating Security Group that Allow All Inbound and Outbound Traffic
resource "aws_security_group" "allowALLSecurityGroup" {
  name        = "AllowALL"
  description = "Allow ALL Inbound Traffic"
  vpc_id      = aws_vpc.VPC.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.securityGroupsTags["Name"]
    Auther = var.securityGroupsTags["Auther"]
    ENV = var.securityGroupsTags["ENV"]
  }
}
