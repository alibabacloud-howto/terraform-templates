provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = var.region
}

variable "region" {
  default = "ap-northeast-1"
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

## PolarDB MySQL Source
resource "alicloud_polardb_cluster" "source" {
  db_type       = "MySQL"
  db_version    = "8.0"
  db_node_class = "polar.mysql.g2.medium"
  pay_type      = "PostPaid"
  vswitch_id    = alicloud_vswitch.default.id
  description   = "PolarDB MySQL as DTS Source"
  parameters {
    name  = "loose_polar_log_bin"
    value = "ON"
  }
}

resource "alicloud_polardb_account" "source_account" {
  db_cluster_id       = alicloud_polardb_cluster.source.id
  account_name        = "test_polardb"
  account_password    = "N1cetest"
  account_description = "PolarDB MySQL as DTS Source"
}

resource "alicloud_polardb_database" "source_db" {
  db_cluster_id = alicloud_polardb_cluster.source.id
  db_name       = "test_database"
}

resource "alicloud_polardb_account_privilege" "source_privilege" {
  db_cluster_id     = alicloud_polardb_cluster.source.id
  account_name      = alicloud_polardb_account.source_account.account_name
  account_privilege = "ReadWrite"
  db_names          = [alicloud_polardb_database.source_db.db_name]
}

## AnalyticDB MySQL Target
resource "alicloud_adb_db_cluster" "target" {
  db_cluster_category = "MixedStorage"
  compute_resource    = "32Core128GB"
  # elastic_io_resource = "2"
  mode               = "flexible"
  db_cluster_version = "3.0"
  payment_type       = "PayAsYouGo"
  vswitch_id         = alicloud_vswitch.default.id
  description        = "AnalyticDB in elastic mode."
  maintain_time      = "23:00Z-00:00Z"
  # security_ips       = ["10.168.1.12", "10.168.1.11"]
}

resource "alicloud_adb_account" "account" {
  db_cluster_id       = alicloud_adb_db_cluster.target.id
  account_name        = "test_adb"
  account_password    = "N1cetest"
  account_description = "AnalyticDB MySQL as DTS Source"
}

## DTS Data Synchronization
resource "alicloud_dts_synchronization_instance" "default" {
  payment_type                     = "PayAsYouGo"
  source_endpoint_engine_name      = "PolarDB"
  source_endpoint_region           = var.region
  destination_endpoint_engine_name = "ADB30"
  destination_endpoint_region      = var.region
  instance_class                   = "small"
  sync_architecture                = "oneway"
}

resource "alicloud_dts_synchronization_job" "default" {
  dts_instance_id                    = alicloud_dts_synchronization_instance.default.id
  dts_job_name                       = "tf-polardbm-adbmysql"
  source_endpoint_instance_type      = "PolarDB"
  source_endpoint_instance_id        = alicloud_polardb_cluster.source.id
  source_endpoint_engine_name        = "PolarDB"
  source_endpoint_region             = var.region
  source_endpoint_database_name      = "test_database"
  source_endpoint_user_name          = alicloud_polardb_account.source_account.account_name
  source_endpoint_password           = alicloud_polardb_account.source_account.account_password
  destination_endpoint_instance_type = "ads"
  destination_endpoint_instance_id   = alicloud_adb_db_cluster.target.id
  destination_endpoint_engine_name   = "ADB30"
  destination_endpoint_region        = var.region
  destination_endpoint_database_name = "test_database"
  destination_endpoint_user_name     = alicloud_adb_account.account.account_name
  destination_endpoint_password      = alicloud_adb_account.account.account_password
  db_list                            = "{\"test_database\":{\"name\":\"test_database\",\"all\":true}}"
  structure_initialization           = "true"
  data_initialization                = "true"
  data_synchronization               = "true"
  status                             = "Synchronizing"
}
