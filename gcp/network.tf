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

resource "google_compute_subnetwork" "subnet_backup" {
  name          = "${local.cluster}-subnet-backup"
  ip_cidr_range = cidrsubnet(var.subnet_cidr, 4, 1)
  network       = google_compute_network.vpc.name
  depends_on    = [google_compute_network.vpc]
  region        = var.region
}

