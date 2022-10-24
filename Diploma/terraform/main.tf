data "yandex_compute_image" "image-type" {
  family = "ubuntu-2004-lts"
}
data "yandex_compute_image" "nat-image" {
  family = "nat-instance-ubuntu"
}

resource "yandex_compute_instance" "nat_instance" {
  name     = "nat"
  hostname = "nat"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat-image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_vpc_subnet.id
    nat_ip_address = ""
    nat       = true
  }

  metadata = {
    test     = "test_str"
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

locals{
  instance_map={
    "db01_instance"       = {name = "mysql-master", cores = 4, memory = 4, size = 10},
    "db02_instance"       = {name = "mysql-slave",  cores = 4, memory = 4, size = 10},
    "app_instance"        = {name = "wordpress",    cores = 4, memory = 4, size = 10},
    "monitoring_instance" = {name = "monitoring",   cores = 4, memory = 4, size = 10},
    "gitlab_instance"     = {name = "gitlab",       cores = 8, memory = 8, size = 30},
    "runner_instance"     = {name = "runner",       cores = 4, memory = 4, size = 30}
  }
}

resource "yandex_compute_instance" "instances" {
  for_each = local.instance_map
  name     = "${each.value.name}"
  hostname = "${each.value.name}"
  zone     = "ru-central1-a"

  resources {
    cores  = "${each.value.cores}"
    memory = "${each.value.memory}"
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image-type.id
      size     = "${each.value.size}"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }
}
