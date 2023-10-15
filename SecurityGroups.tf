resource "aws_security_group" "AWS_Stack_beanstalk_elb_sg" {
  name        = "AWS_Stack_beanstalk_elb_sg"
  description = "Security group for beanstalk elb"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "AWS_Stack_bastionhost_sg" {
  name        = "AWS_Stack_bastionhost_sg"
  description = "Security group for bastion host"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.MY_IP]
  }
}

resource "aws_security_group" "AWS_Stack_ec2instance_sg" {
  name        = "AWS_Stack_ec2instance_sg"
  description = "Security group for beanstalck ec2 instances"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [aws_security_group.AWS_Stack_bastionhost_sg.id]
  }
}

resource "aws_security_group" "AWS_Stack_backend_sg" {
  name        = "AWS_Stack_backend_sg"
  description = "Security group for backend services (RDS, Active mq, elastic cache)"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [aws_security_group.AWS_Stack_ec2instance_sg.id]
  }
}

resource "aws_security_group_rule" "allow_backend_sg_itself" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.AWS_Stack_backend_sg.id
  source_security_group_id = aws_security_group.AWS_Stack_backend_sg.id
}