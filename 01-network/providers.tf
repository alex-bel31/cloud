terraform {

  backend "s3" {
      endpoints = {
    s3       = "https://storage.yandexcloud.net"
  }

  region     = "ru-central1"
  bucket     = "novitskiiva-tfstate-k8s" 
  key        = "k8s-infra/tfstate-backend"

  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true 
  skip_s3_checksum            = true 
  # shared_credentials_files = ["~/.aws/credentials"]
  # shared_config_files      = ["~/.aws/config"]
  use_lockfile = true
  }

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.158.0"
    }
  }

  required_version = "~>1.12.0"
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file("~/.ssh/authorized_key.json")
}
