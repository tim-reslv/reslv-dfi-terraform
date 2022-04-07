resource "google_bigquery_dataset" "logging" {
  dataset_id                  = "logging_dataset"
  friendly_name               = "logging"
  description                 = "This is for loggin dataset"
  location                    = var.region
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
  dataset_id = google_bigquery_dataset.logging.dataset_id
  role       = "roles/bigquery.dataViewer"

  members = [
    "user:tim@reslv.io",
  ]
}

resource "google_bigquery_dataset_iam_member" "editor" {
  dataset_id = google_bigquery_dataset.logging.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "user:tim@reslv.io"
}


resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.logging.dataset_id
  table_id   = "bar"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = <<EOF
[
  {
    "name": "permalink",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The Permalink"
  },
  {
    "name": "state",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "State where the head office is located"
  }
]
EOF

}

# resource "google_bigquery_table_iam_policy" "policy" {
#   project = google_bigquery_table.default.project
#   dataset_id = google_bigquery_table.default.dataset_id
#   table_id = google_bigquery_table.default.table_id
#   policy_data = data.google_iam_policy.owner.policy_data
# }
# 
resource "google_bigquery_table_iam_binding" "binding" {
  project = google_bigquery_table.default.project
  dataset_id = google_bigquery_table.default.dataset_id
  table_id = google_bigquery_table.default.table_id
  role = "roles/bigquery.dataOwner"
  members = [
      "user:kenny@reslv.io",
      "user:nicole@reslv.io"
  ]
}

resource "google_bigquery_table_iam_member" "viewer" {
  project = google_bigquery_table.default.project
  dataset_id = google_bigquery_table.default.dataset_id
  table_id = google_bigquery_table.default.table_id
  role = "roles/bigquery.dataViewer"
  members = [
    "user:tim@reslv.io"
  ]
}