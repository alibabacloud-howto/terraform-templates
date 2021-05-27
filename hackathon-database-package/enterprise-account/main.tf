provider "alicloud" {
  ## This is ENTERPRISE ACCOUNT ONLY !!!
  ## Please make sure the account you used is enterprise account !!!

  # PLEASE USE one of following regions: 
  # US(Silicon Valley): us-west-1 
  # Singapore: ap-southeast-1
  # UK(London): eu-west-1
  # Australia(Sydney): ap-southeast-2
  # China(Hong Kong): cn-hongkong

  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}

data "alicloud_zones" "default" {
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

# Cassandra Free Trial
resource "alicloud_cassandra_cluster" "default" {
  cluster_name        = "cassandra-free-trial"
  data_center_name    = "dc-1"
  auto_renew          = "false"
  instance_type       = "cassandra.c.large" # 2C4G
  major_version       = "3.11"
  node_count          = "2"          # 2 nodes
  pay_type            = "PayAsYouGo" # Must be Subscription
  vswitch_id          = alicloud_vswitch.default.id
  disk_size           = "160"
  disk_type           = "cloud_efficiency" # Ultra disk
  maintain_start_time = "18:00Z"
  maintain_end_time   = "20:00Z"
  ip_white            = "127.0.0.1"
}

# HBase Free Trial
resource "alicloud_hbase_instance" "default" {
  name           = "hbase-free-trial"
  zone_id        = data.alicloud_zones.default.zones[0].id
  engine         = "hbase"
  engine_version = "2.0"
  ## Master & core instance type MUST BE one of the following types:
  ## hbase.sn1.large: 4C 8G
  ## hbase.sn2.large: 4C 16G
  ## hbase.sn1.2xlarge: 8C 16G
  master_instance_type   = "hbase.sn2.large" # <= 8C16G
  core_instance_type     = "hbase.sn2.large" # <= 8C16G
  core_instance_quantity = 2
  core_disk_type         = "cloud_efficiency"
  core_disk_size         = 400
  pay_type               = "PostPaid" # Must be PrePaid
  vswitch_id             = alicloud_vswitch.default.id
  cold_storage_size      = 0
  maintain_start_time    = "02:00Z"
  maintain_end_time      = "04:00Z"
  deletion_protection    = true
  immediate_delete_flag  = false
  ip_white               = "127.0.0.1"
}

# MongoDB Free Trial
resource "alicloud_mongodb_instance" "example" {
  engine_version       = "4.2"                # 3.4/4.0/4.2
  db_instance_class    = "dds.mongo.standard" # 2C4G
  db_instance_storage  = 20
  replication_factor   = 3
  instance_charge_type = "PostPaid" # Must be PrePaid
  vswitch_id           = alicloud_vswitch.default.id
}

# Redis Free Trial
resource "alicloud_kvstore_instance" "example" {
  db_instance_name = "redis-free-trial"
  vswitch_id       = alicloud_vswitch.default.id
  instance_type    = "Redis"
  engine_version   = "5.0" # 4.0 or 5.0
  config = {
    appendonly             = "yes",
    lazyfree-lazy-eviction = "yes",
  }
  tags = {
    Created = "TF",
    For     = "Test",
  }
  resource_group_id = "rg-free-trial"
  payment_type      = "PostPaid" # Must be PrePaid
  zone_id           = data.alicloud_zones.default.zones[0].id
  instance_class    = "redis.master.large.default" # Standard 8GB master-replica
}

# PolarDB MySQL Always Free
resource "alicloud_polardb_cluster" "cluster" {
  db_type       = "MySQL"
  db_version    = "8.0"                   # 5.6, 5.7, or 8.0
  db_node_class = "polar.mysql.g4.medium" # 2C8G general purpose
  pay_type      = "PostPaid"              # Need to be PrePaid
  vswitch_id    = alicloud_vswitch.default.id
  description   = "Hackathon PolarDB MySQL instance"
}
