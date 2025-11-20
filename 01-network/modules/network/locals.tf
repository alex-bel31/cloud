locals {
  next_hop_address = (
    var.use_nat_instance ? var.nat_instance_address :
    var.use_nat_gateway  ? yandex_vpc_gateway.nat[0].id :
    null
  )
}