# Provider

terraform {
  required_providers {
    linode = {
        source = "linode/linode"
    }
  }
}

variable "api_token" {
  type = string
  default = "h808ty99m7s4rfvyltc22w603cxf8leel1o0t7kmq0g6ry42w7mwkeeqp6lgi2sy" # It is a Random character need to replace
}

provider "linode" {
  token = var.api_token
}

resource "linode_instance" "snapshot_instance" {
  label = "Zeeve_Snapshot_Instance"
  region = "ap-west"
  type = "g6-standard-6"
  image = "linode/ubuntu20.04"
  authorized_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuE8Bx4Cxtv+JYSwbcCJG82FFei0kllnzXVCO8nugKaLFfsnPfFVVSVIG5gOpgordVqRoXfnMFsL4z//4LeGfh6ZneM2t4YudrD67CPh0C9uEXxOVM8u6BDu2wN8OZewgKCvJsz7v05rSfHYMfQWhLdxO1QuLnC2Qex6OOOiL56FIdIZinzLEXgB4AL+80GuwUWlwJtRQvJZmm1EBogoH5e/4nfO6zH5bH2Q2/BPOUfeYwllE+L396/V7lfzZ9Ypd01CIynI/ETiMKJMjIGjXWpWeqbqSk9iFwy9EuQ0D2I5kBrLzPpvYCYelBeBpwUnM3zVkWEEEFEar0UYHQ/QWyB6HsuiIl49cgAkrwMNGC6a6M1MGnxLbr2cCURcAvC7TWCYxn7V8Bvl7/xbRUVBjEfxJkXZuRFUD4m1gAIJ20PXqz4QSP8PjNGECQUGuPHBpTtgw4tp/xxI7i9dsuNNkiExKA5v4lER5czlvkPv28rtHI8s7uRTw5VdC/ChFXCqU= gautam@21-ZEE-LAP023"]
  root_pass = "mLGCTk5gV&+f"

  
}

resource "linode_volume" "snap_volume" {
  label = "snap_volume"
  size = 2900
  region = "ap-west"
  linode_id = linode_instance.snapshot_instance.id
}


output "public_ip" {
  value = linode_instance.snapshot_instance.ip_address
}

