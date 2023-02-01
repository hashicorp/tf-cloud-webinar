# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  labels = {
    cluster = local.cluster
  }
}

resource "google_container_cluster" "kubernetes" {
  name       = "${local.cluster}-cluster"
  location   = var.region
  network    = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  min_master_version = data.google_container_engine_versions.current.latest_master_version

  initial_node_count = var.node_count

  resource_labels = local.labels

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    machine_type = var.machine_type
    preemptible  = true

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = local.labels
    tags   = concat(keys(local.labels), values(local.labels))
  }

  network_policy {
    enabled = true
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = true
    }
    kubernetes_dashboard {
      disabled = true
    }
  }
}
