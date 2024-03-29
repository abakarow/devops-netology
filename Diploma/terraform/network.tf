resource "yandex_vpc_network" "vpc_network" {  name = "vpc-network" }

resource "yandex_vpc_subnet" "private_vpc_subnet" {
  name           = "private-vpc-subnet"
  network_id     = yandex_vpc_network.vpc_network.id
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.1.0/24"]
  route_table_id = yandex_vpc_route_table.nat_vpc_route_table.id
}

resource "yandex_vpc_subnet" "public_vpc_subnet" {
  name           = "public-vpc-subnet"
  network_id     = yandex_vpc_network.vpc_network.id
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.2.0/24"]
}

resource "yandex_dns_zone" "dns_zone" {
  name = "public-dns-zone"
  zone             = "abakarow.ru."
  public           = true
  private_networks = [yandex_vpc_network.vpc_network.id]
}

resource "yandex_dns_recordset" "www_recordset" {
  zone_id = yandex_dns_zone.dns_zone.id
  for_each = toset( ["www", "gitlab", "grafana", "prometheus","alertmanager"] )
  name = "${each.key}.abakarow.ru."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address]
}

resource "yandex_vpc_route_table" "nat_vpc_route_table" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.vpc_network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat_instance.network_interface.0.ip_address
  }
}
