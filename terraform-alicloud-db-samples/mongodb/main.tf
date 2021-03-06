provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-hongkong"
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
  engine_version      = "4.2"
  db_instance_class   = "dds.mongo.mid"
  db_instance_storage = 10
  vswitch_id          = alicloud_vswitch.default.id
}

resource "alicloud_mongodb_account" "example" {
  account_name        = "root"
  account_password    = "N1cetest"
  instance_id         = alicloud_mongodb_instance.example.id
  account_description = "example_value"
}

######### Output: MongoDB instance id
output "mongodb_replicaset_instance_id" {
  value = alicloud_mongodb_instance.example.id
}

######### Output: MongoDB replica_sets information
output "mongodb_replica_sets" {
  value = alicloud_mongodb_instance.example.replica_sets
}
