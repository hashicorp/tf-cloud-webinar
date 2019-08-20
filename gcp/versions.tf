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
