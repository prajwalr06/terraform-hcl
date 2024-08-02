resource "aws_instance" "my_instance" {
  ami                         = "******"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.atps.id]

  tags = {
    Name = "VPC-Task-Public-Subnet"
  }
}

output "public_ip" {
  value = aws_instance.my_instance.public_ip
}


#Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

#NAT Gateway
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
