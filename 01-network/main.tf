module "network" {
  source    = "./modules/network"
  folder_id = var.folder_id
  env_name  = "dev"
  subnets   = var.subnets
  use_nat_instance = true
  nat_instance_address = "192.168.10.254"
  # use_nat_gateway = true
}

module "vm_public" {
  source                 = "./modules/vms"
  env_name               = "dev"
  network_id             = module.network.network_id
  subnet_ids             = [local.public_subnets["ru-central1-a"].id]
  subnet_zones           = [local.public_subnets["ru-central1-a"].zone]
  instance_name          = "nat-instance"
  instance_count         = 1
  image_family           = "nat-instance-ubuntu"
  public_ip              = true
  platform               = "standard-v3"
  instance_core_fraction = 20
  instance_memory        = 1
  instance_cores = 2
  ip_address = "192.168.10.254"

  metadata = {
    user-data = templatefile("${path.module}/templates/cloud-init.tpl", {
      ssh_public_key = file("~/.ssh/yavm.pub")
      user           = var.ssh_username
    })
  }
}

module "vm_private" {
  source                 = "./modules/vms"
  env_name               = "dev"
  network_id             = module.network.network_id
  subnet_ids             = [local.private_subnets["ru-central1-b"].id]
  subnet_zones           = [local.private_subnets["ru-central1-b"].zone]
  instance_name          = "private"
  instance_count         = 1
  image_family           = "ubuntu-2204-lts"
  public_ip              = false
  platform               = "standard-v3"
  instance_core_fraction = 20
  instance_memory        = 1
  instance_cores = 2

  metadata = {
    user-data = templatefile("${path.module}/templates/cloud-init.tpl", {
      ssh_public_key = file("~/.ssh/yavm.pub")
      user           = var.ssh_username
    })
  }
}