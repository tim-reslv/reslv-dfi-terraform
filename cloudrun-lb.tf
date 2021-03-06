# [START cloudloadbalancing_ext_http_cloudrun]
module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 5.1"
  name    = "tf-cr-lb"
  project = var.project_id

  ssl                             = var.ssl
  managed_ssl_certificate_domains = [var.domain]
  https_redirect                  = var.ssl

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.serverless_neg.id
        }
      ]
      enable_cdn              = false
      security_policy         = google_compute_security_policy.apigateway-sec-policy.id
      custom_request_headers  = null
      custom_response_headers = null

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }
}

resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  provider              = google-beta
  name                  = "serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_service.dfi-cloud-run.name
  }
}

resource "google_cloud_run_service" "dfi-cloud-run" {
  name     = "dfi-cloud-run"
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/dfi-yuu/dfi-cloud-run:v5.0"
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "public-access" {
  location = google_cloud_run_service.dfi-cloud-run.location
  project  = google_cloud_run_service.dfi-cloud-run.project
  service  = google_cloud_run_service.dfi-cloud-run.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
# [END cloudloadbalancing_ext_http_cloudrun]
