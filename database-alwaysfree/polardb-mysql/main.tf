provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"

  # Always free PolarDB is only available at regions: 
  # US(Silicon Valley): us-west-1 
  # Singapore: ap-southeast-1
  # UK(London): eu-west-1
  # Australia(Sydney): ap-southeast-2
  # China(Hong Kong): cn-hongkong
  # 
  # Please select one of these regions.
  region = "ap-southeast-1"
}

variable "polardb_mysql_name" {
  default = "polardb_mysql"
}

variable "creation" {
  default = "PolarDB"
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

resource "alicloud_polardb_cluster" "cluster" {
  db_type       = "MySQL"
  db_version    = "8.0"                   # 5.6, 5.7, or 8.0
  db_node_class = "polar.mysql.g4.medium" # 2C8G general purpose
  pay_type      = "PrePaid"              # Need to be PrePaid
  vswitch_id    = alicloud_vswitch.default.id
  description   = var.polardb_mysql_name
}

resource "alicloud_polardb_account" "account" {
  db_cluster_id       = alicloud_polardb_cluster.cluster.id
  account_name        = "test_polardb"
  account_password    = "N1cetest"
  account_description = var.polardb_mysql_name
}

resource "alicloud_polardb_database" "default" {
  db_cluster_id = alicloud_polardb_cluster.cluster.id
  db_name       = "test_database"
}

resource "alicloud_polardb_account_privilege" "privilege" {
  db_cluster_id     = alicloud_polardb_cluster.cluster.id
  account_name      = alicloud_polardb_account.account.account_name
  account_privilege = "ReadWrite"
  db_names          = [alicloud_polardb_database.default.db_name]
}
