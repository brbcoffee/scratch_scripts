output "ec2_linux_ami_id" {
  value = "${data.aws_ami.ec2-linux.id}"
}
output "worker_elb_dns" {
  value = "${aws_elb.worker_elb.dns_name}"
}