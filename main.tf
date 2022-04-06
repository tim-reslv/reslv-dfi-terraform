provider "google" {
 project     = "dfi-yuu"
 region      = "asia-east2"
}

resource "google_bigtable_instance" "dev-bigtable-instance" {
  name = "dev-bigtable-instance"
  deletion_protection = false

  cluster {
    cluster_id   = "tf-instance-cluster"
    num_nodes    = 1
    storage_type = "SSD"
  }

  lifecycle {
    prevent_destroy = false
  }

  labels = {
    my-label = "prod-label"
  }

}

resource "google_bigtable_table" "prd-bigtable-table" {
  name          = "prd-bigtable-table"
  instance_name = google_bigtable_instance.dev-bigtable-instance.name

  lifecycle {
    prevent_destroy = false
  }

}
