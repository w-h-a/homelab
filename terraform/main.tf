data "digitalocean_kubernetes_versions" "k8s" {
  version_prefix = "${var.k8s_version}."
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "${var.name}-${var.region}"
  region  = var.region
  version = data.digitalocean_kubernetes_versions.k8s.latest_version

  node_pool {
    name       = "default"
    size       = var.node_size
    node_count = var.node_count
  }
}

resource "digitalocean_firewall" "cluster" {
  name = "${var.name}-firewall"

  tags = ["k8s:${digitalocean_kubernetes_cluster.cluster.id}"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
