data "yandex_iam_service_account" "instance_group" {
  name = "instance-group"
} 

module "network" {
  source    = "./modules/network"
  folder_id = var.folder_id
  env_name  = "dev"
  subnets   = var.subnets
  # use_nat_instance = true
  # nat_instance_address = "192.168.10.254"
  # use_nat_gateway = true
}

resource "yandex_storage_object" "img" {
  bucket = "novitskiiva-tfstate-k8s"
  key    = "k8s-infra/test"
  source = "./img/map-vpc.JPG"
  tags = {
    test = "value"
  }
}

resource "yandex_compute_instance_group" "tg_1" {
  name                = "tg-1"
  folder_id           = var.folder_id
  service_account_id  = data.yandex_iam_service_account.instance_group.id
  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
      core_fraction = 20
    }
    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 10
        type = "network-hdd"
      }
    }

    scheduling_policy {
    preemptible = true
    }
    
    network_interface {
      network_id = module.network.network_id
      subnet_ids = ["${local.public_subnets["ru-central1-a"].id}", "${local.public_subnets["ru-central1-b"].id}"]
    }
    metadata = {
      user-data = templatefile("${path.module}/templates/cloud-init.tpl", {
        ssh_public_key = file("~/.ssh/yavm.pub")
        user           = var.ssh_username
      })
    }
  }

  load_balancer {
    # ignore_health_checks = true
    target_group_name = "nlb-tg"
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a","ru-central1-b"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
}

resource "yandex_lb_network_load_balancer" "nlb" {
  name = "nlb"

  listener {
    name = "nlb-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.tg_1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
      interval = 5
      timeout  = 3
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }
}