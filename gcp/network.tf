// Create VPC
resource "google_compute_network" "vpc" {
  name                    = "${local.cluster}-vpc"
  auto_create_subnetworks = "false"
}

// Create Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${local.cluster}-subnet"
  ip_cidr_range = cidrsubnet(var.subnet_cidr, 4, 0)
  network       = google_compute_network.vpc.name
  depends_on    = [google_compute_network.vpc]
  region        = var.region
}

