data "digitalocean_kubernetes_versions" "k8s" {
  version_prefix = "${var.k8s_version}."
}

data "digitalocean_sizes" "nodes" {
  filter {
    key    = "vcpus"
    values = var.node_cpu
  }

  filter {
    key    = "memory"
    values = var.node_memory
  }

  filter {
    key    = "regions"
    values = [var.region]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "${var.name}-${var.region}"
  region  = var.region
  version = data.digitalocean_kubernetes_versions.k8s.latest_version

  node_pool {
    name       = "default"
    size       = element(data.digitalocean_sizes.nodes.sizes, 0).slug
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
