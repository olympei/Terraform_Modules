# store variable definitions
alb_name = "aws-alb"
tg_name = "temp-tg"

load_balancer_type= "application"
private_key_path= "./infra/alb/terraform-key.pem"
alb_protocol = "HTTP"
alb_action_type = "forward"
alb_target_group_protocol= "HTTP"
aws_lb_target_group_port = "80"
