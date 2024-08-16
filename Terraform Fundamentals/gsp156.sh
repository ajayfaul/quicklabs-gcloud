terraform

touch instance.tf

cat <<EOF > instance.tf
resource "google_compute_instance" "terraform" {
  project      = ""
  name         = "terraform"
  machine_type = "e2-medium"
  zone         = ""

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
EOF

terraform init

terraform plan

terraform apply -auto-approve

terraform show