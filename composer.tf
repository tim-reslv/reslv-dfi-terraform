resource "google_composer_environment" "dev" {
  name   = "dev"
  region = "asia-east2"
  config {

    software_config {
      image_version = "composer-2-airflow-2.2.3"
    }

    workloads_config {
      scheduler {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
        count      = 1
      }
      web_server {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
      }
      worker {
        cpu = 2
        memory_gb  = 8
        storage_gb = 10
        min_count  = 3
        max_count  = 3
      }


    }
    environment_size = "ENVIRONMENT_SIZE_SMALL"

    node_config {
      network    = google_compute_network.dev-composer-network.id
      subnetwork = google_compute_subnetwork.dev-composer-subnetwork.id
      service_account = google_service_account.dev-composer-service-account.name
    }
  }
}

resource "google_compute_network" "dev-composer-network" {
  name                    = "dev-composer-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev-composer-subnetwork" {
  name          = "dev-composer-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "asia-east2"
  network       = google_compute_network.dev-composer-network.id
}

resource "google_service_account" "dev-composer-service-account" {
  account_id   = "dev-composer-service-account"
  display_name = "Test Service Account for Composer Environment"
}

resource "google_project_iam_member" "dev-composer-worker" {
  project = "dfi-yuu"
  role    = "roles/composer.worker"
  member  = "serviceAccount:${google_service_account.dev-composer-service-account.email}"
}
