# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = "~> 0.12"

  backend "remote" {}
}

provider "google" {
  version     = "~> 2.8"
  region      = var.region
  project     = var.project
  credentials = var.credentials
}
