output "subnet_info" {
  value = [
    for idx, s in var.subnets : {
      id        = yandex_vpc_subnet.subnet[idx].id
      zone      = yandex_vpc_subnet.subnet[idx].zone
      cidr      = yandex_vpc_subnet.subnet[idx].v4_cidr_blocks[0]
      is_public = s.is_public
      role      = s.role
    }
  ]
}

output "network_id" {
  value = yandex_vpc_network.network.id
}
