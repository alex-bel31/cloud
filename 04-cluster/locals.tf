locals {
  mysql_hosts = [
    for idx, s in module.network.subnet_info :
    {
      name      = "mysql-${idx}"
      zone      = s.zone
      subnet_id = s.id
    }
    if s.role == "db"
  ]
}

locals {
  k8s_node = [
    for s in module.network.subnet_info :
    s.id
    if s.role == "worker"
  ]
}