provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = var.region
}

variable "region" {
  default = "ap-northeast-1"
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

## RDS MySQL Source
resource "alicloud_db_instance" "source" {
  engine           = "MySQL"
  engine_version   = "8.0"
  instance_type    = "rds.mysql.s1.small"
  instance_storage = "10"
  vswitch_id       = alicloud_vswitch.default.id
  instance_name    = "rds-mysql-source"
}

resource "alicloud_db_database" "source_db" {
  instance_id = alicloud_db_instance.source.id
  name        = "test_database"
}

resource "alicloud_rds_account" "source_account" {
  db_instance_id   = alicloud_db_instance.source.id
  account_name     = "test_mysql"
  account_password = "N1cetest"
}

resource "alicloud_db_account_privilege" "source_privilege" {
  instance_id  = alicloud_db_instance.source.id
  account_name = alicloud_rds_account.source_account.name
  privilege    = "ReadWrite"
  db_names     = alicloud_db_database.source_db.*.name
}

## PolarDB MySQL Target
resource "alicloud_polardb_cluster" "target" {
  db_type       = "MySQL"
  db_version    = "8.0"
  db_node_class = "polar.mysql.g2.medium"
  pay_type      = "PostPaid"
  vswitch_id    = alicloud_vswitch.default.id
  description   = "PolarDB MySQL as DTS Target"
  parameters {
    name  = "loose_polar_log_bin"
    value = "ON"
  }
}

resource "alicloud_polardb_account" "target_account" {
  db_cluster_id       = alicloud_polardb_cluster.target.id
  account_name        = "test_polardb"
  account_password    = "N1cetest"
  account_description = "PolarDB MySQL as DTS Target"
}

## DTS Data Synchronization
resource "alicloud_dts_synchronization_instance" "default" {
  payment_type                     = "PayAsYouGo"
  source_endpoint_engine_name      = "MySQL"
  source_endpoint_region           = var.region
  destination_endpoint_engine_name = "PolarDB"
  destination_endpoint_region      = var.region
  instance_class                   = "small"
  sync_architecture                = "bidirectional"
}

resource "alicloud_dts_synchronization_job" "default" {
  synchronization_direction          = "Forward"
  dts_instance_id                    = alicloud_dts_synchronization_instance.default.id
  dts_job_name                       = "tf-rdsmysql-polardbmysql"
  source_endpoint_instance_type      = "RDS"
  source_endpoint_instance_id        = alicloud_db_instance.source.id
  source_endpoint_engine_name        = "MySQL"
  source_endpoint_region             = var.region
  source_endpoint_database_name      = "test_database"
  source_endpoint_user_name          = alicloud_rds_account.source_account.account_name
  source_endpoint_password           = alicloud_rds_account.source_account.account_password
  destination_endpoint_instance_type = "PolarDB"
  destination_endpoint_instance_id   = alicloud_polardb_cluster.target.id
  destination_endpoint_engine_name   = "PolarDB"
  destination_endpoint_region        = var.region
  destination_endpoint_database_name = "test_database"
  destination_endpoint_user_name     = alicloud_polardb_account.target_account.account_name
  destination_endpoint_password      = alicloud_polardb_account.target_account.account_password
  db_list                            = "{\"test_database\":{\"name\":\"test_database\",\"all\":true}}"
  structure_initialization           = "true"
  data_initialization                = "true"
  data_synchronization               = "true"
  status                             = "Synchronizing"
}

resource "alicloud_dts_synchronization_job" "reverse" {
  synchronization_direction          = "Reverse"
  dts_instance_id                    = alicloud_dts_synchronization_instance.default.id
  dts_job_name                       = "tf-polardbmysql-rdsmysql"
  source_endpoint_instance_type      = "PolarDB"
  source_endpoint_instance_id        = alicloud_polardb_cluster.target.id
  source_endpoint_engine_name        = "PolarDB"
  source_endpoint_region             = var.region
  source_endpoint_database_name      = "test_database"
  source_endpoint_user_name          = alicloud_polardb_account.target_account.account_name
  source_endpoint_password           = alicloud_polardb_account.target_account.account_password
  destination_endpoint_instance_type = "RDS"
  destination_endpoint_instance_id   = alicloud_db_instance.source.id
  destination_endpoint_engine_name   = "MySQL"
  destination_endpoint_region        = var.region
  destination_endpoint_database_name = "test_database"
  destination_endpoint_user_name     = alicloud_rds_account.source_account.account_name
  destination_endpoint_password      = alicloud_rds_account.source_account.account_password
  db_list                            = "{\"test_database\":{\"name\":\"test_database\",\"all\":true}}"
  structure_initialization           = "true"
  data_initialization                = "true"
  data_synchronization               = "true"
  status                             = "Synchronizing"
}