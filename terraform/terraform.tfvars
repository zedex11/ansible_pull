project_id      = "devops-lab-summer"
us_region       = "us-central1"
us_zone         = "us-central1-c"
eu_region       = "europe-west1"
eu_zone         = "europe-west1-b"
network_name    = "network"
ssh_username    = "obstaclex"
ssh_key         = "~/.ssh/id_rsa.pub"
ansible_startup = "ansible.sh"

custom_rules = {
  extarnal-firewall = {
    action  = "allow"
    ranges  = ["0.0.0.0/0"]
    sources = []
    targets = []
    rules = [
      {
        protocol = "icmp"
        ports    = []
      },
      {
        protocol = "tcp"
        ports    = ["22", "80", "3306"]
      }
    ]
  }
}