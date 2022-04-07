resource "google_composer_environment" "dev" {
  name = "dev-composer"
  region = var.region

  config {
    node_count = 3
    node_config {
      zone = var.zone
      machine_type = "n1-standard-2"
      service_account = "1025339549236-compute@developer.gserviceaccount.com"
      oauth_scopes = "[https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/bigquery]"
#      node_count = 3
      disk_size_gb = 100

    }
    software_config {
      image_version = "composer-1.18.5-airflow-2.2.3"
      python_version = "3"
      scheduler_count = 1
    }

    database_config {
      machine_type = "db-n1-standard-2"
    }

    web_server_config {
      machine_type = "composer-n1-webserver-2"
    }

  }

  labels = {
    owner = "engineering-team"
    env = "development"
  }

}

resource "google_compute_network" "dev-composer-network" {
  name                    = "dev-composer-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev-composer-subnetwork" {
  name          = "dev-composer-subnetwork"
  ip_cidr_range = "10.170.0.0/20"
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