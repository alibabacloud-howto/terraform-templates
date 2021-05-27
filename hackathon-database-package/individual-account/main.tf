provider "alicloud" {
  ## This is INDIVIDUAL ACCOUNT ONLY !!!
  ## Please make sure the account you used is individual account !!!

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

# MongoDB Free Trial
resource "alicloud_mongodb_instance" "example" {
  engine_version       = "4.2"           # 3.4/4.0/4.2
  db_instance_class    = "dds.mongo.mid" # 1C2G
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
  instance_class    = "redis.master.stand.default" # Standard 4GB master-replica
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
