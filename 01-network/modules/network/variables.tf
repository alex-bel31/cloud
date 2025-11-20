variable "folder_id" {
  type        = string
  description = "Folder ID"
  sensitive = true
}

variable "env_name" {
  type        = string
  description = "Network name"
}


variable "subnets" {
  description = "Location area and CIDR block for subnetwork"
  type = map(object({
    zone      = string
    cidr      = string
    is_public = bool
  }))
}

variable "use_nat_instance" {
  type    = bool
  default = false
}

variable "nat_instance_address" {
  type      = string
  default   = null
}

variable "use_nat_gateway" {
  type    = bool
  default = false
}