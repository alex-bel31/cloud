variable "name" {
  description = "Name of MySQL cluster"
  type        = string
  default     = "mysql-cluster"
}

variable "environment" {
  description = "Environment type: PRODUCTION or PRESTABLE"
  type        = string
  default     = "PRESTABLE"
  validation {
    condition     = contains(["PRODUCTION", "PRESTABLE"], var.environment)
    error_message = "PRODUCTION or PRESTABLE"
  }
}

variable "network_id" {
  description = "Network id"
  type        = string
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0"
}

variable "security_groups_ids_list" {
  description = "A list of security group IDs"
  type        = list(string)
  default     = []
}

variable "disk_size" {
  description = "Disk size for hosts"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Disk type for hosts"
  type        = string
  default     = "network-hdd"
}

variable "resource_preset_id" {
  description = "Preset for hosts"
  type        = string
  default     = "b1.medium"
}

variable "deletion_protection" {
  description = "Protection against unintentional cluster deletion"
  type        = bool
  default     = true
}

variable "hosts" {
  description = "List of MySQL hosts"
  type = list(object({
    name      = string
    zone      = string
    subnet_id = string
  }))
}

variable "maintenance_window" {
  description = "Maintenance window"
  type = object({
    type = string
    day  = optional(string) 
    hour = optional(number) 
  })
  default = {
    type = "ANYTIME"
  }
}

variable "backup_window_start" {
  description = "Backup start time"
  type = object({
    hours   = number
    minutes = number
  })
  default = {
    hours   = 23
    minutes = 0
  }
}

variable "databases" {
  description = "List of MySQL databases"
  type = list(object({
    name = string
  }))
  default = []
}

variable "users" {
  description = "MySQL user list"
  type = list(object({
    name     = string
    password = string
  }))
  default = []
}