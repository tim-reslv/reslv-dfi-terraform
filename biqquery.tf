resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "example_dataset"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "HK"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bqowner.email
  }

}

resource "google_service_account" "bqowner" {
  account_id = "bqowner"
}

data "google_iam_policy" "owner" {
  binding {
    role = "roles/bigquery.dataOwner"

    members = [
      "user:kenny@reslv.io",
      "user:nicole@reslv.io"
    ]
  }
}

resource "google_bigquery_dataset_iam_binding" "reader" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  role       = "roles/bigquery.dataViewer"

  members = [
    "user:tim@reslv.io",
  ]
}

resource "google_bigquery_dataset_iam_member" "editor" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "user:tim@reslv.io"
}