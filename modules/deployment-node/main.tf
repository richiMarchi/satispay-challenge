resource "aws_instance" "node" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  subnet_id                   = var.subnet_id
  user_data                   = file("modules/deployment-node/init_vm.sh")
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  key_name                    = var.key_name
}

resource "aws_eip" "lb" {
  instance = aws_instance.node.id
  vpc      = true
}

resource "aws_lb_target_group" "http_traffic" {
  name     = "http-traffic"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "http_traffic" {
  target_group_arn = aws_lb_target_group.http_traffic.arn
  target_id        = aws_instance.node.id
  port             = 80
}

resource "aws_lb_listener" "http_traffic" {
  load_balancer_arn = var.alb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http_traffic.arn
  }
}

resource "aws_lb_target_group" "be_traffic" {
  name     = "be-traffic"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "be_traffic" {
  target_group_arn = aws_lb_target_group.be_traffic.arn
  target_id        = aws_instance.node.id
  port             = 8080
}

resource "aws_lb_listener" "be_traffic" {
  load_balancer_arn = var.alb_arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.be_traffic.arn
  }
}
