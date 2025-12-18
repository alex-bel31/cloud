locals {
  nat_instance_next_hop = var.use_nat_instance ? var.nat_instance_address : null
  nat_gateway_id        = var.use_nat_gateway  ? yandex_vpc_gateway.nat[0].id : null
}