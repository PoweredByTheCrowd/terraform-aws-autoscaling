data "template_file" "user-data" {

  template = "${file(var.userdata_path)}"

  vars {
    authorized_keys       =  "  - ${join("\n  - ", split("\n", trimspace(file(var.authorized_keys))))}"
    rancher_url           = "${var.rancher_registration_url}"
    docker_version        = "${var.docker_version}"
    rancher_agent_version = "${var.rancher_agent_version}"
  }
}
