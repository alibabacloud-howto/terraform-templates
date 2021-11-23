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

#https://www.alibabacloud.com/help/doc-detail/276975.htm
resource "alicloud_db_instance" "master" {
  engine                   = "MySQL"
  engine_version           = "8.0"
  instance_type            = "mysql.x2.medium.2c"
  instance_storage         = "50"
  db_instance_storage_type = "cloud_essd"
  instance_charge_type     = "Postpaid"
  vswitch_id               = alicloud_vswitch.default.id
  instance_name            = var.rds_mysql_name
}

# https://www.alibabacloud.com/help/doc-detail/276980.htm
resource "alicloud_db_readonly_instance" "readonly" {
  master_db_instance_id = alicloud_db_instance.master.id
  zone_id               = alicloud_db_instance.master.zone_id
  engine_version        = alicloud_db_instance.master.engine_version
  instance_type         = "mysqlro.x8.medium.1c"
  instance_storage      = "300"
  instance_name         = "${var.rds_mysql_name}_ro"
  vswitch_id            = alicloud_vswitch.default.id
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.master.id
  name        = "test_database"
}

resource "alicloud_db_account" "account" {
  db_instance_id   = alicloud_db_instance.master.id
  account_name     = "test_mysql"
  account_password = "N1cetest"
}

resource "alicloud_db_account_privilege" "privilege" {
  instance_id  = alicloud_db_instance.master.id
  account_name = alicloud_db_account.account.name
  privilege    = "ReadWrite"
  db_names     = alicloud_db_database.default.*.name
}
