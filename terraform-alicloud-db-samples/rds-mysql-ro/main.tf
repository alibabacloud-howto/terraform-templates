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

resource "alicloud_db_instance" "primary" {
  engine               = "MySQL"
  engine_version       = "8.0"
  instance_type        = "rds.mysql.t1.small"
  instance_storage     = "20"
  instance_charge_type = "Postpaid"
  instance_name        = var.rds_mysql_name
  vswitch_id           = alicloud_vswitch.default.id
  security_ips         = ["10.168.1.12", "100.69.7.112"]
}

resource "alicloud_db_readonly_instance" "ro" {
  master_db_instance_id = alicloud_db_instance.primary.id
  zone_id               = alicloud_db_instance.primary.zone_id
  engine_version        = alicloud_db_instance.primary.engine_version
  instance_type         = alicloud_db_instance.primary.instance_type
  instance_storage      = "30"
  instance_name         = "${var.rds_mysql_name}ro"
  vswitch_id            = alicloud_vswitch.default.id
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.primary.id
  name        = "test_database"
}

resource "alicloud_rds_account" "account" {
  db_instance_id   = alicloud_db_instance.primary.id
  account_name     = "test_mysql"
  account_password = "N1cetest"
}

resource "alicloud_db_account_privilege" "privilege" {
  instance_id  = alicloud_db_instance.primary.id
  account_name = alicloud_rds_account.account.name
  privilege    = "ReadWrite"
  db_names     = alicloud_db_database.default.*.name
}

######### Output: RDS MySQL Primary Connection String
output "rds_mysql_primary_url" {
  value = alicloud_db_instance.primary.connection_string
}

######### Output: RDS MySQL Primary Connection Port
output "rds_mysql_primary_port" {
  value = alicloud_db_instance.primary.port
}

######### Output: RDS MySQL Read-Only Connection String
output "rds_mysql_readonly_url" {
  value = alicloud_db_readonly_instance.ro.connection_string
}

######### Output: RDS MySQL Read-Only Connection Port
output "rds_mysql_readonly_port" {
  value = alicloud_db_readonly_instance.ro.port
}

