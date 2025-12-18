resource "yandex_vpc_network" "network" {
  name = "${var.env_name}-vpc"
}

resource "yandex_vpc_gateway" "nat" {
  count     = var.use_nat_gateway ? 1 : 0
  name      = "${var.env_name}-nat-gateway"
  folder_id = var.folder_id
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private" {
  count      = var.use_nat_gateway || var.use_nat_instance ? 1 : 0
  name       = "${var.env_name}-private-rt"
  folder_id  = var.folder_id
  network_id = yandex_vpc_network.network.id

  dynamic "static_route" {
    for_each = var.use_nat_instance ? [1] : []
    content {
      destination_prefix = "0.0.0.0/0"
      next_hop_address  = local.nat_instance_next_hop
    }
  }

  dynamic "static_route" {
    for_each = var.use_nat_gateway ? [1] : []
    content {
      destination_prefix = "0.0.0.0/0"
      gateway_id        = local.nat_gateway_id
    }
  }
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = { for idx, s in var.subnets : idx => s }
  name           = "${var.env_name}-${each.key}"
  zone           = each.value.zone
  v4_cidr_blocks = [each.value.cidr]
  network_id     = yandex_vpc_network.network.id

  route_table_id = each.value.is_public ? null : (yandex_vpc_route_table.private != [] ? yandex_vpc_route_table.private[0].id : null)
}