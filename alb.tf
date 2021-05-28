# aws_lb.application-lb: Creation complete after 3m12s
resource "aws_lb" "application-lb" {
  provider           = aws.region-master
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]                    # list of SG
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id] # list of Subnets for HA
  tags = {
    Name = "Application-LB"
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region-master
  name        = "app-lb-tg"
  port        = var.webserver-port
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_master.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.webserver-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "master-target-group"
  }
}

resource "aws_lb_listener" "master-listener-http" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.id
  }
}

resource "aws_lb_target_group_attachment" "master-attach" {
  provider         = aws.region-master
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = aws_instance.master-instance.id
  port             = var.webserver-port
}
