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


# resource "aws_ebs_volume" "puppetmaster_host_ebs" {
#     availability_zone = "us-west-2c"
#     size = 10
#     tags {
#         Name = "puppetmaster_ebs"
#     }
# }

# resource "aws_volume_attachment" "ebs_attach_puppetmaster" {
#   device_name = "/dev/sdh"
#   volume_id   = "${aws_ebs_volume.puppetmaster_host_ebs.id}"
#   instance_id = "${aws_instance.puppetmaster.id}"
#   skip_destroy = "true"
# }

resource "aws_instance" "puppetmaster" {
  ami           = "ami-91b95ae9"
  instance_type = "t2.micro"
  key_name = "devenv-key"
  vpc_security_group_ids = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
  subnet_id     = "subnet-401d891b"
  private_ip = "172.31.1.1"

  tags {
    Name = "puppetmaster"
  }

  ebs_block_device{
    device_name = "/dev/sdh"
    volume_size = 5
    volume_type = "gp2"
  }

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
    source = ".ssh/git"
    destination = "/var/tmp/git"
  }
  provisioner "file" {
    source = "provision_scripts/mount_vol_and_git.sh"
    destination = "/var/tmp/mount_vol_and_git.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /var/tmp/run_puppet.sh",
      "chmod 400 /var/tmp/key",
      "/var/tmp/run_puppet.sh",
      "chmod +x /var/tmp/mount_vol_and_git.sh",
      "/var/tmp/mount_vol_and_git.sh",     
    ]
  }

}

resource "aws_instance" "webserver" {
  ami           = "ami-60d83b18"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
  subnet_id     = "subnet-401d891b"

  tags {
    Name = "webserver"
  }

  ebs_block_device{
    device_name = "/dev/sdh"
    volume_size = 5
    volume_type = "gp2"
  }

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
    source = ".ssh/git"
    destination = "/var/tmp/git"
  }
  provisioner "file" {
    source = "provision_scripts/mount_vol_and_git.sh"
    destination = "/var/tmp/mount_vol_and_git.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /var/tmp/run_puppet.sh",
      "chmod 400 /var/tmp/key",
      "/var/tmp/run_puppet.sh",
      "chmod +x /var/tmp/mount_vol_and_git.sh",
      "/var/tmp/mount_vol_and_git.sh",     
    ]
  }
}

resource "aws_instance" "nagios_server" {
  ami           = "ami-f78a678f"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
  subnet_id     = "subnet-401d891b"

  tags {
    Name = "nagios_server"
  }

  ebs_block_device{
    device_name = "/dev/sdh"
    volume_size = 5
    volume_type = "gp2"
  }

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
    source = ".ssh/git"
    destination = "/var/tmp/git"
  }
  provisioner "file" {
    source = "provision_scripts/mount_vol_and_git.sh"
    destination = "/var/tmp/mount_vol_and_git.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /var/tmp/run_puppet.sh",
      "chmod 400 /var/tmp/key",
      "/var/tmp/run_puppet.sh",
      "chmod +x /var/tmp/mount_vol_and_git.sh",
      "/var/tmp/mount_vol_and_git.sh",     
    ]
  }
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-1c01ec64"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
  subnet_id     = "subnet-401d891b"

  tags {
    Name = "jenkins_server"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("${var.private_key_path}")}"
  }

  ebs_block_device{
    device_name = "/dev/sdh"
    volume_size = 5
    volume_type = "gp2"
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
    source = ".ssh/git"
    destination = "/var/tmp/git"
  }
  provisioner "file" {
    source = "provision_scripts/mount_vol_and_git.sh"
    destination = "/var/tmp/mount_vol_and_git.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /var/tmp/run_puppet.sh",
      "chmod 400 /var/tmp/key",
      "/var/tmp/run_puppet.sh",
      "chmod +x /var/tmp/mount_vol_and_git.sh",
      "/var/tmp/mount_vol_and_git.sh",     
    ]
  }
}

resource "aws_instance" "yt_script_worker01" {
  ami           = "ami-0cb95574"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
  subnet_id     = "subnet-401d891b"

  tags {
    Name = "yt_script_worker01"
  }

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
    source = ".ssh/git"
    destination = "/var/tmp/git"
  }
  provisioner "file" {
    source = "provision_scripts/mount_vol_and_git.sh"
    destination = "/var/tmp/mount_vol_and_git.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /var/tmp/run_puppet.sh",
      "chmod 400 /var/tmp/key",
      "/var/tmp/run_puppet.sh",
      "chmod +x /var/tmp/mount_vol_and_git.sh",
      "/var/tmp/mount_vol_and_git.sh",     
    ]
  }
}

resource "aws_instance" "yt_script_worker02" {
  ami           = "ami-0cb95574"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
  subnet_id     = "subnet-401d891b"

  tags {
    Name = "yt_script_worker02"
  }

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
    source = ".ssh/git"
    destination = "/var/tmp/git"
  }
  provisioner "file" {
    source = "provision_scripts/mount_vol_and_git.sh"
    destination = "/var/tmp/mount_vol_and_git.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /var/tmp/run_puppet.sh",
      "chmod 400 /var/tmp/key",
      "/var/tmp/run_puppet.sh",
      "chmod +x /var/tmp/mount_vol_and_git.sh",
      "/var/tmp/mount_vol_and_git.sh",     
    ]
  }
}


resource "aws_elb" "worker_elb" {
  name               = "worker-elb"
  availability_zones =  ["us-west-2a", "us-west-2b", "us-west-2c"]


  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances                   = ["${aws_instance.yt_script_worker01.id}", "${aws_instance.yt_script_worker02.id}"]

  tags {
    Name = "worker_elb"
  }
}


# to be used for new ami creation
#resource "aws_instance" "base_ami" {
# ami           = "${data.aws_ami.ec2-linux.id}"
# instance_type = "t2.micro"
# key_name = "devenv-key"
# security_groups = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
# subnet_id     = "subnet-401d891b"

#}

# resource "aws_network_interface" "multi-ip" {
#   subnet_id   = "subnet-401d891b"
#   private_ips = ["172.31.11.11", "172.31.11.12"]
# }

# resource "aws_eip" "worker_eip01" {
#   private_ip = "172.31.11.11"
#   network_interface         = "${aws_network_interface.multi-ip.id}"
#   #associate_with_private_ip = "172.31.11.11"
#   instance = "${aws_instance.yt_script_worker01.id}"
#   vpc      = true
# }

# resource "aws_eip" "worker_eip02" {
#   private_ip = "172.31.11.12"
#   network_interface         = "${aws_network_interface.multi-ip.id}"
#   #associate_with_private_ip = "172.31.11.12"
#   instance = "${aws_instance.yt_script_worker02.id}"
#   vpc      = true
# }

# resource "aws_s3_bucket" "example-bucket" {
#  bucket = "example-bucket-us-west-2-terraform"
#  acl    = "private"
#  force_destroy = true
# }

# to be used for new ami creation
# resource "aws_instance" "basic_ami" {
#  ami           = "${data.aws_ami.ec2-linux.id}"
#  instance_type = "t2.micro"
#  key_name = "devenv-key"
#  security_groups = [ "${aws_security_group.ssh_access.id}", "${aws_security_group.internal_access.id}" ]
#  subnet_id     = "subnet-401d891b"

# }






