resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public"
  }
  availability_zone = "eu-south-1a"
}

resource "aws_subnet" "publicB" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public B"
  }
  availability_zone = "eu-south-1b"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "web_server" {
  name        = "web_server"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP to VM"
      from_port        = 80
      to_port          = 80
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "SSH to VM"
      from_port        = 22
      to_port          = 22
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "HTTP to VM"
      from_port        = 8080
      to_port          = 8080
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web_server"
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "load_balancer"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP to VM"
      from_port        = 80
      to_port          = 80
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "HTTP to VM"
      from_port        = 8080
      to_port          = 8080
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "load_balancer"
  }
}
