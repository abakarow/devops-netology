# Generate variables for ansible
# resource "local_file" "ansible_var" {
#   content = <<-EOT
#   app_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["app_instance"].network_interface.0.ip_address}"
#   db01_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["db01_instance"].network_interface.0.ip_address}"
#   db02_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["db02_instance"].network_interface.0.ip_address}"
#   entrance_jjvodvoevodin_ru_ip_addr_external: "${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}"
#   entrance_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.nat_instance.network_interface.0.ip_address}"
#   gitlab_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["gitlab_instance"].network_interface.0.ip_address}"
#   monitoring_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["monitoring_instance"].network_interface.0.ip_address}"
#   runner_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["runner_instance"].network_interface.0.ip_address}"
#   EOT
#   filename = "../ansible/roles/variables.yml"

#   depends_on = [
#     yandex_compute_instance.nat_instance,
#     yandex_compute_instance.instances["db01_instance"],
#     yandex_compute_instance.instances["db02_instance"],
#     yandex_compute_instance.instances["app_instance"],
#     yandex_compute_instance.instances["monitoring_instance"],
#     yandex_compute_instance.instances["gitlab_instance"],
#     yandex_compute_instance.instances["runner_instance"]
#   ]
# }

resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 100"
  }

  depends_on = [
    #local_file.ansible_var,
    yandex_dns_recordset.www_recordset,
    yandex_compute_instance.nat_instance,
    yandex_compute_instance.instances["db01_instance"],
    yandex_compute_instance.instances["db02_instance"],
    yandex_compute_instance.instances["app_instance"],
    yandex_compute_instance.instances["monitoring_instance"],
    yandex_compute_instance.instances["gitlab_instance"],
    yandex_compute_instance.instances["runner_instance"]
  ]
}

resource "null_resource" "entrance" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook ../ansible/roles/entrance/tasks/main.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook ../ansible/roles/db/tasks/main.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "wordpress" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook ../ansible/roles/app/tasks/main.yml"
  }

  depends_on = [
    null_resource.cluster
  ]
}

resource "null_resource" "monitoring" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook ../ansible/roles/monitoring/tasks/main.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "gitlab" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook ../ansible/roles/gitlab/tasks/main.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}
