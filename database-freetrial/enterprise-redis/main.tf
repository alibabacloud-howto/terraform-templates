provider "alicloud" {
  ## This is ENTERPRISE ACCOUNT ONLY !!!
  ## Please make sure the account you used is enterprise account !!!

  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}

variable "redis_name" {
  default = "redis"
}

variable "creation" {
  default = "KVStore"
}

data "alicloud_zones" "default" {
  available_resource_creation = var.creation
}

resource "alicloud_vpc" "default" {
  vpc_name   = "vpc-test"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "default" {
  vpc_id       = alicloud_vpc.default.id
  cidr_block   = "172.16.0.0/24"
  zone_id      = data.alicloud_zones.default.zones[0].id
  vswitch_name = "vsw-test"
}

resource "alicloud_kvstore_instance" "example" {
  db_instance_name = "redis-free-trial"
  vswitch_id       = alicloud_vswitch.default.id
  instance_type    = "Redis"
  engine_version   = "5.0" # 4.0 or 5.0
  config = {
    appendonly             = "yes",
    lazyfree-lazy-eviction = "yes",
  }
  tags = {
    Created = "TF",
    For     = "Test",
  }
  resource_group_id = "rg-free-trial"
  payment_type      = "PostPaid" # Must be PrePaid
  zone_id           = data.alicloud_zones.default.zones[0].id
  instance_class    = "redis.master.large.default" # Standard 8GB master-replica
}
