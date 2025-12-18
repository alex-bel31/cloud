resource "yandex_mdb_mysql_cluster" "mdb_mysql_cluster" {
  name               = var.name
  environment        = var.environment
  network_id         = var.network_id
  version            = var.mysql_version
  security_group_ids = var.security_groups_ids_list

  deletion_protection = var.deletion_protection

  resources {
    resource_preset_id = var.resource_preset_id
    disk_type_id       = var.disk_type
    disk_size          = var.disk_size
  }

  backup_window_start {
    hours   = var.backup_window_start.hours
    minutes = var.backup_window_start.minutes
  }

  maintenance_window {
    type = var.maintenance_window.type
    day  = var.maintenance_window.type == "WEEKLY" ? var.maintenance_window.day  : null
    hour = var.maintenance_window.type == "WEEKLY" ? var.maintenance_window.hour : null
  }

  dynamic "host" {
    for_each = var.hosts
    content {
      name      = host.value.name
      zone      = host.value.zone
      subnet_id = host.value.subnet_id
    }
  }
}

resource "yandex_mdb_mysql_database" "database" {
  for_each   = length(var.databases) > 0 ? { for db in var.databases : db.name => db } : {}
  cluster_id = yandex_mdb_mysql_cluster.mdb_mysql_cluster.id
  name       = lookup(each.value, "name", null)
}

resource "yandex_mdb_mysql_user" "user" {
  for_each   = length(var.users) > 0 ? { for user in var.users : user.name => user } : {}
  cluster_id = yandex_mdb_mysql_cluster.mdb_mysql_cluster.id
  name       = each.value.name
  password   = each.value.password
  depends_on = [yandex_mdb_mysql_database.database]
}