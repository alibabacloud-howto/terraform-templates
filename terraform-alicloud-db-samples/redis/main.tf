provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-hongkong"
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
  db_instance_name = "tf-test-basic"
  vswitch_id       = alicloud_vswitch.default.id
  security_ips     = ["10.23.12.24"]
  instance_type    = "Redis"
  engine_version   = "5.0"
  config = {
    appendonly             = "yes",
    lazyfree-lazy-eviction = "yes",
  }
  tags = {
    Created = "TF",
    For     = "Test",
  }
  resource_group_id = "rg-123456"
  zone_id           = data.alicloud_zones.default.zones[0].id

  ##### Instance class: https://www.alibabacloud.com/help/doc-detail/26350.htm

  ##### Standard master-replica instances
  # instance_class    = "redis.amber.master.small.multithread"

  ##### Cluster instances
  instance_class = "redis.amber.logic.sharding.1g.2db.0rodb.6proxy.multithread"

  ##### Read/write splitting instances SUPPORTED
  # instance_class = "redis.amber.logic.splitrw.small.1db.1rodb.6proxy.multithread"

  # ssl_enable        = "Enable"
}
