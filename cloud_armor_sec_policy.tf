resource "google_compute_security_policy" "apigateway-sec-policy" {
  name = "apigateway-sec-policy"

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }

  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["114.37.147.144/32","61.93.230.193/32"]
      }
    }
    description = "Allow access from IPs in 114.37.147.144/32, 61.93.230.193/32"
  }
}