resource "aws_db_subnet_group" "AWS_Stack_rds_subgrp" {
  name       = "main-subnet"
  subnet_ids = module.vpc.private_subnets[*]
  tags = {
    Desciption = "rds subnet group"
  }
}

resource "aws_elasticache_subnet_group" "AWS_Stack_ecache_subgrp" {
  name       = "AWS_Stack_ecache_subgrp"
  subnet_ids = module.vpc.private_subnets[*]
  tags = {
    Desciption = "elastic cache subnet group"
  }
}

resource "aws_db_instance" "AWS_Stack_rds" {
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.6.34"
  db_name                = var.dbname
  username               = var.dbuser
  password               = var.dbpass
  parameter_group_name   = "default.mysql5.6"
  multi_az               = "false"
  publicly_accessible    = "false"
  skip_final_snapshot    = "true"
  db_subnet_group_name   = aws_db_subnet_group.AWS_Stack_rds_subgrp.name
  vpc_security_group_ids = [aws_security_group.AWS_Stack_backend_sg.id]
}

resource "aws_elasticache_cluster" "AWS_Stack_ecache" {
  cluster_id           = "aws-stack-ecache"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.5"
  port                 = 11211
  security_group_ids   = [aws_security_group.AWS_Stack_backend_sg.id]
  subnet_group_name    = aws_security_group.AWS_Stack_bastionhost_sg.name
}

resource "aws_mq_broker" "AWS_Stack_rmq" {
  broker_name        = "AWS_Stack_rmq"
  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.AWS_Stack_backend_sg.id]
  subnet_ids         = [module.vpc.private_subnets[0]]
  user {
    username = var.rmquser
    password = var.rmqpass
  }
}