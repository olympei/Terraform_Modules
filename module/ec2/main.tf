# Create IAM role for CloudWatch custom metrics
resource "aws_iam_role" "cloudwatch_role" {
  name = "CloudWatchEC2Role"
  
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Attach CloudWatch policies to the IAM role
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_readonly_policy_attachment" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_read_only_policy_attachment" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# Attach IAM role to the EC2 instance
resource "aws_iam_instance_profile" "instance_profile" {
  name = "CloudWatchEC2InstanceProfile"
  role = aws_iam_role.cloudwatch_role.name
}

# Attach IAM policy to the IAM role to allow describing EC2 instances
resource "aws_iam_role_policy" "describe_ec2_policy" {
  name   = "DescribeEC2Policy"
  role   = aws_iam_role.cloudwatch_role.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "ec2:DescribeInstances",
        "Resource": "*"
      }
    ]
  })
}

# Create EC2 instance
resource "aws_instance" "public_server" {
  ami           = "ami-0cf10cdf9fcd62d37"
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id     = data.aws_subnet.public_subnet-1.id
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  security_groups = [aws_security_group.ec2_public_sg.id]

user_data = <<-EOF
    #!/bin/bash
    yum update -y # Update packages (assuming Amazon Linux 2)
    yum install -y unzip perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Sys-Hostname # Install necessary packages
    
    # Download CloudWatchMonitoringScripts
    curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O

    # Unzip the downloaded file
    unzip CloudWatchMonitoringScripts-1.2.2.zip

    # Change directory to aws-scripts-mon
    cd /aws-scripts-mon
    
    # Install perl-App-cpanminus {{ it installs the Perl module Digest::SHA. This module is required by the AWS CloudWatch monitoring scripts, particularly for generating signatures when communicating with AWS APIs.}}
    sudo yum install perl-Digest-SHA -y

    # Set execution permission to the script
    chmod +x mon-put-instance-data.pl

    # Run mon-put-instance-data.pl with memory utilization to verify the installation
    ./mon-put-instance-data.pl --mem-util --verify --verbose
    ./mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/

    # Set up the cron job
    (crontab -l ; echo "*/5     /aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --from-cron") | crontab -
  EOF

  
  tags = {
    "Name" = "${var.namespace}_public"
  }
}




# Create security group for public ec2
resource "aws_security_group" "ec2_public_sg" {
  name        = "ec2_public_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.main-vpc.id

  tags = {
    Name = "ec2_public_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_port" {
  security_group_id = aws_security_group.ec2_public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "https_port" {
  security_group_id = aws_security_group.ec2_public_sg.id
  cidr_ipv4         = data.aws_vpc.main-vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http_port" {
  security_group_id = aws_security_group.ec2_public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic" {
  security_group_id = aws_security_group.ec2_public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
 
#---------------------------------------------------------------------------------------------------------- 
# Create EC2 instance in a private subnet ##
#----------------------------------------------------------------------------------------------------------
resource "aws_instance" "ec2_private" {
  ami                         = "ami-0cf10cdf9fcd62d37"
  associate_public_ip_address = false
  instance_type               = var.private_server_instance_type
  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = data.aws_subnet.private-subnet-ec2.id
  security_groups = [aws_security_group.ec2_private_sg.id]
  
  tags = {
    "Name" = "${var.namespace}_private"
  }



} 

# # Create security group for private ec2
resource "aws_security_group" "ec2_private_sg" {
  name        = "ec2_private_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.main-vpc.id

  tags = {
    Name = "ec2_private_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_https_port" {
  security_group_id = aws_security_group.ec2_private_sg.id
  cidr_ipv4         = data.aws_vpc.main-vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "priavte_http_port" {
  security_group_id = aws_security_group.ec2_private_sg.id
  cidr_ipv4         = data.aws_vpc.main-vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "outbount_traffic" {
  security_group_id = aws_security_group.ec2_private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#---------------------------------------------------------------------------------------------------------
# Create a key pair for the EC2 instance
#----------------------------------------------------------------------------------------------------------
resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.namespace}-key"  # Specify the name of the key pair
  public_key = tls_private_key.ec2_key.public_key_openssh  # Provide the path to the public key file
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename          = "${var.namespace}-key.pem"
  content           = tls_private_key.ec2_key.private_key_pem
  file_permission   = "0400"
}
