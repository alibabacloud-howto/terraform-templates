provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-hongkong"
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
  zone_id      = data.alicloud_zones.default.zones[0].id
  vswitch_name = "vsw-test"
}

resource "alicloud_db_instance" "instance" {
  engine           = "MySQL"
  engine_version   = "8.0"
  instance_type    = "rds.mysql.s1.small"
  instance_storage = "10"
  vswitch_id       = alicloud_vswitch.default.id
  instance_name    = var.rds_mysql_name
  security_ips     = ["0.0.0.0/0"]
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.instance.id
  name        = "test_database"
}

resource "alicloud_rds_account" "super_account" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "super_test_mysql"
  account_password = "N1cetest"
  account_type     = "Super"
}

resource "alicloud_rds_account" "normal_account_1" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "test_mysql_1"
  account_password = "password1"
  account_type     = "Normal"
}

resource "alicloud_rds_account" "normal_account_2" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "test_mysql_2"
  account_password = "password2"
  account_type     = "Normal"
}

resource "alicloud_db_connection" "internet" {
  instance_id = alicloud_db_instance.instance.id
}

resource "null_resource" "setup_db" {
  provisioner "local-exec" {
    command = "mysql -u ${alicloud_rds_account.super_account.account_name} -p${alicloud_rds_account.super_account.account_password} -h ${alicloud_db_connection.internet.connection_string} -P ${alicloud_db_connection.internet.port} ${alicloud_db_database.default.name} < setup.sql"
  }
}
