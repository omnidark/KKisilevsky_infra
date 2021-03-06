resource "yandex_vpc_network" "app-network" {
  name = "reddit-app-network"
}

resource "yandex_vpc_subnet" "app-subnet" {
  name           = "reddit-app-subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.app-network.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# resource "yandex_vpc_security_group" "group1" {
#   name        = "Firewall"
#   description = "Firewall rules"
#   network_id  = "${yandex_vpc_network.app-network.id}"

# ingress {
#     protocol       = "TCP"
#     description    = "Open port"
#     port           = 80
#   }
# }