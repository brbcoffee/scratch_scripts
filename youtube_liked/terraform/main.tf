provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"

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


resource "aws_ebs_volume" "puppetmaster_host_ebs" {
    availability_zone = "us-west-2c"
    size = 10
    tags {
        Name = "puppetmaster_ebs"
    }
}

resource "aws_instance" "puppetmaster" {
  ami           = "ami-91b95ae9"
  instance_type = "t2.micro"
  key_name = "devenv-key"
  vpc_security_group_ids = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
  subnet_id     = "subnet-401d891b"
  private_ip = "172.31.1.1"

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source = "../puppet_config/"
    destination = "/etc/puppet/"

  }

}

resource "aws_volume_attachment" "ebs_attach_puppetmaster" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.puppetmaster_host_ebs.id}"
  instance_id = "${aws_instance.puppetmaster.id}"
}


resource "aws_instance" "webserver" {
  ami           = "ami-60d83b18"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
  subnet_id     = "subnet-401d891b"

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source = "provision_scripts/run_puppet.sh"
    destination = "/var/tmp/run_puppet.sh"
  }
  provisioner "file" {
    source = ".ssh/devenv-key.pem"
    destination = "/var/tmp/key"
  }
  provisioner "file" {
    source = "provision_scripts/mount_vol.sh"
    destination = "/var/tmp/mount_vol.sh"
  }
  provisioner "file" {
    source = ".ssh/git"
    destination = "/var/tmp/git"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /var/tmp/run_puppet.sh",
      "chmod 400 /var/tmp/key",
      "/var/tmp/run_puppet.sh",
      "chmod +x /var/tmp/mount_vol.sh",
      "chmod 400 /var/tmp/git",
      "/var/tmp/mount_vol.sh",      
    ]
  }
}

resource "aws_ebs_volume" "nagios_host_ebs" {
    availability_zone = "us-west-2c"
    size = 5
    tags {
        Name = "nagios_host_ebs"
    }
}

resource "aws_instance" "nagios_server" {
  ami           = "ami-f78a678f"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
  subnet_id     = "subnet-401d891b"

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source = "provision_scripts/run_puppet.sh"
    destination = "/var/tmp/run_puppet.sh"
  }
  provisioner "file" {
    source = ".ssh/devenv-key.pem"
    destination = "/var/tmp/key"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /var/tmp/run_puppet.sh",
      "chmod 400 /var/tmp/key",
      "/var/tmp/run_puppet.sh"
    ]
  }
}

resource "aws_volume_attachment" "ebs_attach_nagios_server" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.nagios_host_ebs.id}"
  instance_id = "${aws_instance.nagios_server.id}"
}


#to be used for new ami creation
#resource "aws_instance" "basic_ami" {
#  ami           = "${data.aws_ami.ec2-linux.id}"
#  instance_type = "t2.micro"
#  key_name = "devenv-key"
#  security_groups = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
#  subnet_id     = "subnet-401d891b"

#}

#resource "aws_s3_bucket" "example-bucket" {
#  bucket = "example-bucket-us-west-2-terraform"
#  acl    = "private"
#  force_destroy = true
#}



