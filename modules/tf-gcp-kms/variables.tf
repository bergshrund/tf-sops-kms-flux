variable "project_id" {
  description = ""
  type        = string
}

variable "keyring" {
  description = " The resource name for the KeyRing"
  type        = string
}

variable "location" {
  description = "The location for the KeyRing"
  default     = "global"
  type        = string
}

variable "keys" {
  description = "The resource name for the CryptoKeys"
  type        = list(string)
}