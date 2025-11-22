locals {
  public_subnets = {
    for s in module.network.subnet_info :
    s.zone => {
      id = s.id
      zone = s.zone
      cidr = s.cidr
      }
    if s.is_public
  }

  private_subnets = {
    for s in module.network.subnet_info :
    s.zone => {
      id = s.id
      zone = s.zone
      cidr = s.cidr
      }
    if !s.is_public
  }
}