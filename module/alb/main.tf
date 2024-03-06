# Create alb resource
resource "aws_lb" "alb" {
  name                = var.alb_name
  load_balancer_type  = var.load_balancer_type
  # internal            = true
  subnets             = data.aws_subnets.public_subnet.ids
  security_groups     = [aws_security_group.alb_sg.id]

}

# create listner for alb
resource "aws_lb_listener" "http_listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_port
  protocol          = var.alb_protocol

  default_action {
    type             = var.alb_action_type
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }


  # default_action {
  #   type = "redirect"

  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }


}

# resource "aws_lb_listener" "https_listner" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#    certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }
# }

# ssh and install nginx on ec2 instance 
resource "null_resource" "update_instance" {
  triggers = {
    instance_id = data.aws_instance.exsiting_ec2.id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user" # or the appropriate user for your instance
    private_key = file(var.private_key_path) # replace with the path to your private key
    host        = data.aws_instance.exsiting_ec2.public_ip
  }

  provisioner "remote-exec" {
    inline = [
    "sudo yum update -y",
    "sudo amazon-linux-extras install nginx1 -y",
    "sudo systemctl start nginx",
    "sudo mkdir -p /usr/share/nginx/html",
    "echo 'this is my first ALB from Terraform' | sudo tee /usr/share/nginx/html/index.html > /dev/null"
 
    ]
  }
}
################################################
# Create security group for alb
resource "aws_security_group" "alb_sg" {
  name        = "security_group_of_alb_and_ec2"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.main-vpc.id

  ingress {
    from_port   =  80
    to_port     =  80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   =  0
    to_port     =  0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}
#########################################
# resource "aws_security_group" "allow_tls" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic and all outbound traffic"
#   vpc_id      = data.aws_vpc.vpc.id
#   tags = {
#     Name = "EC2-sg"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   # cidr_ipv4         = data.aws_vpc.vpc.cidr_block
#   cidr_ipv4 = "0.0.0.0/0"
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }
# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   # cidr_ipv4         = data.aws_vpc.vpc.cidr_block
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 0
#   ip_protocol       = "-1"
#   to_port           = 0
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4-2" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }
 

resource "aws_lb_target_group" "alb_tg" {
  name     = var.tg_name
  port     = var.aws_lb_target_group_port
  protocol = var.alb_target_group_protocol
  vpc_id   = data.aws_vpc.main-vpc.id
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = data.aws_instance.exsiting_ec2.id           
  port             = 80
}
