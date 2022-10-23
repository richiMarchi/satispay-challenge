module "main_node" {
  source = "./modules/deployment-node"

  subnet_id          = aws_subnet.public.id
  vpc_id             = aws_vpc.main.id
  security_group_ids = [aws_security_group.web_server.id]
  key_name           = aws_key_pair.node_group.key_name
  alb_arn            = aws_lb.ALB_public.arn
}

resource "aws_key_pair" "node_group" {
  key_name   = "node-group-key"
  public_key = local.public_key
}

resource "aws_lb" "ALB_public" {
  name               = "ALB-public"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.publicB.id]
}
