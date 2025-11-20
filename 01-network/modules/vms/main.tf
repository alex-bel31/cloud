data "yandex_compute_image" "my_image" {
  family = var.image_family
}

resource "yandex_compute_instance" "vm" {
  count = var.instance_count

  name               = var.env_name == null ? "${var.instance_name}-${count.index}" : "${var.env_name}-${var.instance_name}-${count.index}"
  platform_id        = var.platform
  hostname           = var.env_name == null ? "${var.instance_name}-${count.index}" : "${var.env_name}-${var.instance_name}-${count.index}"
  zone               = element(var.subnet_zones, count.index)
  description        = "${var.description} {{terraform managed}}"

  scheduling_policy {
    preemptible = var.preemptible
  }

  resources {
    cores         = var.instance_cores
    memory        = var.instance_memory
    core_fraction = var.instance_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.image_id
      type     = var.boot_disk_type
      size     = var.boot_disk_size
    }
  }

  network_interface {
    subnet_id          = element(var.subnet_ids, count.index)
    nat                = var.public_ip
    security_group_ids = var.security_group_ids
    ip_address         = var.ip_address
  }

  metadata = {
    for k, v in var.metadata : k => v
  }
}