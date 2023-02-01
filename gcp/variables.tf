# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "project" {}

variable "region" {}

variable "credentials" {}

variable "subnet_cidr" {}

variable "cluster_name" {}

variable "machine_type" {
  default = "n1-standard-2"
}

variable "node_count" {
  default = "1"
}

variable "num_clusters" {
  default = 1
}
