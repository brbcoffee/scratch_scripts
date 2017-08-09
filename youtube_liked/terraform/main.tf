provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"

}

resource "aws_instance" "puppetmaster" {
  ami           = "ami-6df1e514"
  instance_type = "t2.micro"
  key_name = "devenv-key"
  security_groups = [ "ssh_access", "internal_access" ]
}

resource "aws_instance" "webserver" {
  ami           = "ami-6df1e514"
  instance_type = "t2.micro"
  key_name = "devenv-key"
  security_groups = [ "ssh_access", "internal_access" ]
}

resource "aws_s3_bucket" "example-bucket" {
  bucket = "example-bucket-us-west-2-terraform"
  acl    = "private"
  force_destroy = true
}

resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "ssh_access group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal_access" {
  name        = "internal_access"
  description = "internal_access group"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

