module "network" {
  source    = "./modules/network"
  folder_id = var.folder_id
  env_name  = "dev"
  subnets   = var.subnets
}

module "mysql" {
  source = "./modules/mysql"

  name               = "mysql-stage"
  environment        = "PRESTABLE"
  mysql_version      = "8.0"
  network_id         = module.network.network_id

  resource_preset_id = "b1.medium"
  disk_type          = "network-ssd"
  disk_size          = 20

  hosts = local.mysql_hosts

  maintenance_window = {
    type = "ANYTIME"
  }

  backup_window_start = {
    hours   = 23
    minutes = 59
  }

  deletion_protection = false

  databases = [
    {
      name="netology_db"
    }
  ]
  
  users = [
    {
      name = "test" 
      password = "password1234"
    }
  ]
}
