##
#  Create cloud KMS key ring
##
resource "google_kms_key_ring" "this" {
  name     = var.keyring
  location = var.location
  project  = var.project_id
}

##
#  Create cloud KMS key
##
resource "google_kms_crypto_key" "this" {
  count           = length(var.keys)
  name            = var.keys[count.index]
  key_ring        = google_kms_key_ring.this.id
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = false
  }
}

