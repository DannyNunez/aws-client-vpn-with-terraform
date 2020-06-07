data "aws_acm_certificate" "server" {
  domain = "server"
}

data "aws_acm_certificate" "client" {
  domain = "client1.domain.tld"
}

resource "aws_ec2_client_vpn_endpoint" "dev" {

  description            = "clientvpn-endpoint"
  server_certificate_arn = data.aws_acm_certificate.server.arn
  client_cidr_block      = "172.20.0.0/16"
  split_tunnel           = true

  dns_servers = ["75.75.75.75", "76.76.76.76"]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = data.aws_acm_certificate.client.arn
  }

  connection_log_options {
    enabled = false
  }

}

resource "aws_ec2_client_vpn_network_association" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.dev.id
  subnet_id              = aws_subnet.public_a.id
}

resource "null_resource" "client_vpn_ingress" {
  depends_on = [aws_ec2_client_vpn_endpoint.dev]
  provisioner "local-exec" {
    when    = create
    command = "aws ec2 authorize-client-vpn-ingress --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.dev.id} --target-network-cidr 0.0.0.0/0 --authorize-all-groups"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "export_endpoint_configuration" {
  depends_on = [null_resource.client_vpn_ingress]
  provisioner "local-exec" {
    when    = create
    command = "aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.dev.id}  --output text > ../certs/client-config.ovpn"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "append_client_certificate" {
  depends_on = [null_resource.export_endpoint_configuration]
  provisioner "local-exec" {
    when    = create
    command = "echo 'cert ${replace(path.cwd, "vpc", "certs")}/client1.domain.tld.crt'  >> ../certs/client-config.ovpn"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "append_client_key" {
  depends_on = [null_resource.export_endpoint_configuration]
  provisioner "local-exec" {
    when    = create
    command = "echo 'key ${replace(path.cwd, "vpc", "certs")}/client1.domain.tld.key'  >> ../certs/client-config.ovpn"
  }
  lifecycle {
    create_before_destroy = true
  }
}
