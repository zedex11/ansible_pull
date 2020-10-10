provider "google" {
  project = var.project_id
  region  = var.us_region
}
provider "google" {
  project = var.project_id
  region  = var.eu_region
  alias   = "eu"
}

# terraform {
#   backend "gcs" {
#     bucket = "imelnik1-exit_task"
#     prefix = "ansible-pull/"
#   }
# }


module "firewall" {
  source       = "./modules/firewall"
  network_name = var.network_name
  ports        = var.ports
}

module "tomcat_instance" {
  source         = "./modules/instance"
  instance_count = 1
  zone           = var.us_zone
  name           = "tomcat"
  source_image   = "ansible-pull-image"
  ssh_key        = "${var.ssh_username}:${file(var.ssh_key)}"
  startup_script = file(var.ansible_startup)
  tags       = ["tomcat"]
}

module "httpd_instance" {
  source = "./modules/instance"
  providers = {
    google = google.eu
  }
  zone           = var.eu_zone
  name           = "httpd"
  source_image   = "ansible-pull-image"
  ssh_key        = "${var.ssh_username}:${file(var.ssh_key)}"
  startup_script = file(var.ansible_startup)
  tags       = ["httpd"]
}
