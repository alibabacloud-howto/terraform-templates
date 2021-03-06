provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-3"
}

variable "rds_mysql_name" {
  default = "rds_mysql"
}

resource "alicloud_vpc" "default" {
  vpc_name   = "vpc-test"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "default" {
  vpc_id       = alicloud_vpc.default.id
  cidr_block   = "172.16.0.0/24"
  zone_id      = "ap-southeast-3b"
  vswitch_name = "vsw-test"
}

resource "alicloud_db_instance" "instance" {
  engine                   = "MySQL"
  engine_version           = "8.0"
  instance_type            = "mysql.x2.medium.2c"
  instance_storage         = "50"
  db_instance_storage_type = "cloud_essd"
  vswitch_id               = alicloud_vswitch.default.id
  instance_name            = var.rds_mysql_name
  instance_charge_type     = "Prepaid"
  period                   = 1
  auto_renew               = false
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.instance.id
  name        = "test_database"
}

resource "alicloud_rds_account" "super" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_type     = "Super"
  account_name     = "super_admin"
  account_password = "N1cetest"
}

resource "alicloud_rds_account" "account" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "test_mysql"
  account_password = "N1cetest"
}

resource "alicloud_db_account_privilege" "privilege" {
  instance_id  = alicloud_db_instance.instance.id
  account_name = alicloud_rds_account.account.name
  privilege    = "ReadWrite"
  db_names     = alicloud_db_database.default.*.name
}
