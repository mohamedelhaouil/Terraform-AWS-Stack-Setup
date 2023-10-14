resource "aws_key_pair" "aws-stack-key" {
  key_name   = "aws-stack-key"
  public_key = file(var.PUB_KEY)
}