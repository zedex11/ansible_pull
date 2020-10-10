# ==================== Create instance =============================

resource "google_compute_instance" "default" {
  count        = var.instance_count
  name         = "${var.name}-instance-${count.index + 1}"
  zone         = var.zone
  machine_type = var.machine_type
  tags         = var.tags
  labels       = var.labels
  metadata = {
    ssh-keys = var.ssh_key
  }
  metadata_startup_script = var.startup_script
  boot_disk {
    initialize_params {
      image = var.source_image
    }
  }
  network_interface {
    network    = "default"
    access_config {
    }
  }
}