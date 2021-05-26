provider "alicloud" {
  ## This is ENTERPRISE ACCOUNT ONLY !!!
  ## Please make sure the account you used is enterprise account !!!

  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}

variable "rds_sqlserver_name" {
  default = "rds_sqlserver"
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
  engine                   = "SQLServer"
  engine_version           = "2016_web"           # 2012_web or 2016_web
  instance_type            = "mssql.x2.medium.w1" # 2C4G
  instance_storage         = "20"
  db_instance_storage_type = "cloud_ssd"
  instance_charge_type     = "Postpaid" # Must be Prepaid
  vswitch_id               = alicloud_vswitch.default.id
  instance_name            = var.rds_sqlserver_name
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.instance.id
  name        = "test_database"
}
