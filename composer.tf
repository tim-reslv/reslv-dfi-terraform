resource "google_composer_environment" "dev" {
  name = "dev-composer"
  region = var.region

  config {

    node_config {
      service_account = "example-account@example-project.iam.gserviceaccount.com"
#      oauth_scopes = "[https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/bigquery]"
#      node_count = 4
      disk_size_gb = 100
      zone = var.zone
      machine_type = "n1-standard-2"
    }

    software_config {
      python_version = "3"
      image_version = "composer-1.18.4-airflow-1.10.15"
      scheduler_count = 1
    }

#    database_config {
#      machine_type = "db-n1-standard-2"
#    }
#    web_server_config {
#      machine_type = "composer-n1-webserver-2"
#    }
#    web_server_network_access_control {
#      allowed_ip_range {
#        value = "192.0.2.0/24"
#        description = "office net 1"
#      }
#      allowed_ip_range {
#        value = "192.0.4.0/24"
#        description = "office net 3"
#      }
#    }

#    maintenance_window {
#      start_time = "2021-01-01T01:00:00Z"
#      end_time = "2021-01-01T07:00:00Z"
#      recurrence = "FREQ=WEEKLY;BYDAY=SU,WE,SA"
#    }

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
