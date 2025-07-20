vm1 = {
  name = "vm1"
  target_node = "pve"
  vmid = "100"
  memory = "4096"
  sockets = "1"
  cores = "2"
  os_type = "cloud-init"
}

vm1_container1 = {
  image = "ubuntu"
  restart = "unless-stopped"
  ports = ["80:80"]
  volumes = ["/data:/data"]
  environment = ["FOO=bar"]
}

lxc1 = {
  hostname = "lxc1"
  target_node = "pve"
  vmid = "101"
  memory = "1024"
  cores = "1"
}
