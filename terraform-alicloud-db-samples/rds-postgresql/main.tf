provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-5"
}

variable "rds_postgresql_name" {
  default = "rds_postgresql"
}

variable "creation" {
  default = "Rds"
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

resource "alicloud_db_instance" "instance" {
  engine           = "PostgreSQL"
  engine_version   = "13.0"
  instance_type    = "pg.n2.small.1" ## pg.n2.small.1(Basic 1C2GB), pg.n2.small.2c (HA 1C2GB)
  instance_storage = "20"
  vswitch_id       = alicloud_vswitch.default.id
  instance_name    = var.rds_postgresql_name
  # instance_charge_type = "Postpaid"
  instance_charge_type = "Prepaid"
  period               = 1
  auto_renew           = false
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.instance.id
  name        = "test_database"
}
