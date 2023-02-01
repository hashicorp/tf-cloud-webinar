# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  cluster = "${var.cluster_name}"
}

data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
}

data "google_container_engine_versions" "current" {
  location = var.region
}
