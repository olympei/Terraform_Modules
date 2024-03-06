module "alb" {
    source = "../../module/alb"

    alb_name = var.alb_name
    tg_name = var.tg_name
    load_balancer_type = var.load_balancer_type
    private_key_path = var.private_key_path
    alb_protocol = var.alb_protocol
    alb_action_type = var.alb_action_type
    alb_target_group_protocol = var.alb_target_group_protocol
    aws_lb_target_group_port = var.aws_lb_target_group_port
}
