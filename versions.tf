terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.18"

    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.18"
    }
  }
  required_version = ">= 0.13"
}
