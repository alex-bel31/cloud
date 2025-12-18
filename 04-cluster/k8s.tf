data "yandex_iam_service_account" "k8s_service_account_id" {
  name = "k8s-service-account"
} 

resource "yandex_kms_symmetric_key" "key-k8s" {
  name              = "k8s-symetric-key"
  description       = "symmetric k8s key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}

resource "yandex_kubernetes_cluster" "regional_cluster" {
  name        = "k8s"

  network_id = module.network.network_id

  master {
    regional {
      region = "ru-central1"

      dynamic "location" {
        for_each = {for s in module.network.subnet_info : s.zone => s if s.role == "master"} 
        content {
        zone      = location.value.zone
        subnet_id = location.value.id
        }
      }
    }

    version   = "1.32"
    public_ip = true
  }

  service_account_id      = data.yandex_iam_service_account.k8s_service_account_id.id
  node_service_account_id = data.yandex_iam_service_account.k8s_service_account_id.id

  release_channel = "STABLE"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = yandex_kms_symmetric_key.key-k8s.id
  }
  
}

resource "yandex_kubernetes_node_group" "k8s-node-group" {
  cluster_id = yandex_kubernetes_cluster.regional_cluster.id
  name       = "k8s-node-group"
  version = "1.32"

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat        = true
      subnet_ids = local.k8s_node
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    container_runtime {
      type = "containerd"
    }

    scheduling_policy {
      preemptible = true
    }

  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }
  allocation_policy {
    location {
    zone = "ru-central1-a"
    }
  }  
}
