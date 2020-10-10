resource "google_compute_firewall" "external" {
  name           = "external"
  network        = var.network_name
  allow {
    protocol     = "tcp"
    ports        = var.ports
  }
  source_ranges = ["0.0.0.0/0"]
}