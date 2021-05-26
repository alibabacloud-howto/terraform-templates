provider "alicloud" {
  ## This is INDIVIDUAL ACCOUNT ONLY !!!
  ## Please make sure the account you used is individual account !!!

  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}

variable "mongodb_name" {
  default = "mongodb"
}

variable "creation" {
  default = "MongoDB"
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

resource "alicloud_mongodb_instance" "example" {
  engine_version       = "4.2"           # 3.4/4.0/4.2
  db_instance_class    = "dds.mongo.mid" # 1C2G
  db_instance_storage  = 20
  replication_factor   = 3
  instance_charge_type = "PostPaid" # Must be PrePaid
  vswitch_id           = alicloud_vswitch.default.id
}
