variable "region" {}
variable "region_abbr" {}
variable "dns_zone_id" {}
variable "dns_name" {}

provider "aws" {
  region = var.region
}

resource "aws_lightsail_instance" "lambda_edge_demo_instance" {
  name              = "lambda-edge-demo-${var.region}"
  availability_zone = "${var.region}a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "small_2_0"
  user_data = <<EOF
    #!/bin/bash
    sudo apt update
    sudo apt install docker.io -y
    sudo docker run -d -p 80:8080 -e LAMBDA_EDGE_DEMO_REGION="${var.region_abbr}" tyurikov/lambda-edge-demo-backend
  EOF
}

resource "aws_lightsail_instance_public_ports" "web_echo_instance_ports" {
  instance_name = aws_lightsail_instance.lambda_edge_demo_instance.name
  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }
}

resource "aws_route53_record" "echo_service_dns" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.dns_name}"
  type    = "A"
  ttl     = "60"
  records = [aws_lightsail_instance.lambda_edge_demo_instance.public_ip_address]
}