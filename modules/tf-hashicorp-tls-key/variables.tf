variable "algorithm" {
  type        = string
  default     = "RSA"
  description = "The cryptographic algorithm (e.g. RSA, ECDSA)"
}

variable "rsa_bits" {
  type        = string
  default     = "2048"
  description = "RSA key size"  
}