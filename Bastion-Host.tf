resource "aws_instance" "AWS_Stack_bastion_host" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.aws-stack-key.key_name
  subnet_id              = module.vpc.public_subnets[0]
  count                  = 1
  vpc_security_group_ids = [aws_security_group.AWS_Stack_bastionhost_sg.id]

  tags = {
    Name    = "AWS_Stack_bastion"
    Project = "AWS_Stack"
  }

  provisioner "file" {
    content     = templatefile("db/db-deploy.tmpl", { rds-endpoint = aws_db_instance.AWS_Stack_rds.address, dbuser = var.dbuser, dbpass = var.dbpass })
    destination = "/tmp/AWS_Stack_dbdeploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/AWS_Stack_dbdeploy.sh",
      "sudo /tmp/AWS_Stack_dbdeploy.sh"
    ]
  }

  connection {
    user        = var.USERNAME
    private_key = file(var.PRIV_KEY)
    host        = self.public_ip
  }
  depends_on = [aws_db_instance.AWS_Stack_rds]
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
output "ubuntu_ami" {
  value = data.aws_ami.ubuntu_ami
}
