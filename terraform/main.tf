provider "google" {
  project = var.project_id
  region  = var.us_region
}
provider "google" {
  project = var.project_id
  region  = var.eu_region
  alias   = "eu"
}

terraform {
  backend "gcs" {
    bucket = "imelnik1-exit_task"
    prefix = "ansible-pull/"
  }
}

module "network" {
  source                  = "./modules/network"
  network_name            = var.network_name
  auto_create_subnetworks = true
}

module "firewall" {
  source       = "./modules/firewall"
  network_name = var.network_name
  custom_rules = var.custom_rules
  depends_on   = [module.network]
}

module "web_instance" {
  source         = "./modules/instance"
  instance_count = 2
  zone           = var.us_zone
  name           = "webapp"
  source_image   = "ansible-pull-image"
  ssh_key        = "${var.ssh_username}:${file(var.ssh_key)}"
  startup_script = file(var.ansible_startup)
  labels = {
    instance = "webapp"
  }
  tags       = ["webapp"]
  depends_on = [module.network]
}

module "db_instance" {
  source = "./modules/instance"
  providers = {
    google = google.eu
  }
  zone           = var.eu_zone
  name           = "db"
  source_image   = "ansible-pull-image"
  ssh_key        = "${var.ssh_username}:${file(var.ssh_key)}"
  startup_script = file(var.ansible_startup)
  labels = {
    instance = "db"
  }
  tags       = ["db"]
  depends_on = [module.network]
}

module "check_instance" {
  source         = "./modules/instance"
  zone           = var.us_zone
  name           = "db-check"
  source_image   = "ansible-pull-image"
  ssh_key        = "${var.ssh_username}:${file(var.ssh_key)}"
  startup_script = file(var.ansible_startup)
  labels = {
    instance = "db-check"
  }
  tags       = ["db-check"]
  depends_on = [module.network]
}