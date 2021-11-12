resource "aws_lb" "app" {
  name               = "hashicups-backend-${var.pull_request_id}"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.network.outputs.public_subnets
  security_groups    = [data.terraform_remote_state.network.outputs.hashicups_security_group_id]
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hashicups-backend.arn
  }
}

resource "aws_lb_target_group" "hashicups-backend" {
  name     = "hcup-be-${var.pull_request_id}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id

  health_check {
    port     = 8080
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "hashicups-backend" {
  target_group_arn = aws_lb_target_group.hashicups-backend.arn
  target_id        = aws_instance.hashicups-backend.id
  port             = 8080
}