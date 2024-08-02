#Route table for the private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }
}

#private route table with the private subnet
resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

#launch an instance in the private subnet
resource "aws_instance" "private_instance" {
  ami                         = "********"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = false
  security_groups             = [aws_security_group.atps.id]

  tags = {
    Name = "VPC-Task-Private-Subnet"
  }
}

output "private_ip" {
  value = aws_instance.private_instance.private_ip
}

#private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "ap-south-1a"
}
