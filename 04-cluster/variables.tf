variable "env_name" {
  description = "Network name"
  type        = string
}

variable "cloud_id" {
  type        = string
  description = "Cloud ID"
  sensitive   = true
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
  sensitive   = true
}

variable "default_zone" {
  type        = string
  description = "Default zone"
  sensitive   = true
}

variable "subnets" {
  type = map(object({
    zone      = string
    cidr      = string
    is_public = bool
  }))
}


