provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-shanghai"
}

variable "zone_1" {
  default = "cn-shanghai-g"
}

variable "rds_mysql_name" {
  default = "rds_mysql"
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
  zone_id      = var.zone_1
  vswitch_name = "vsw-test"
}

resource "alicloud_db_instance" "instance" {
  engine               = "MySQL"
  engine_version       = "8.0"
  instance_type        = "mysql.n4.medium.25" # Enterprise Edition
  instance_storage     = "100"
  zone_id              = var.zone_1
  zone_id_slave_a      = "Auto"
  zone_id_slave_b      = "Auto"
  vswitch_id           = join(",", [alicloud_vswitch.default.id, "Auto", "Auto"])
  instance_name        = var.rds_mysql_name
  instance_charge_type = "Postpaid"
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.instance.id
  name        = "test_database"
}

resource "alicloud_db_account" "account" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "test_mysql"
  account_password = "N1cetest"
}

resource "alicloud_db_account_privilege" "privilege" {
  instance_id  = alicloud_db_instance.instance.id
  account_name = alicloud_db_account.account.name
  privilege    = "ReadWrite"
  db_names     = alicloud_db_database.default.*.name
}
