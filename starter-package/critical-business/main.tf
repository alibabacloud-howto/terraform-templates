provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}

variable "name" {
  default = "auto_provisioning_group"
}

######## Security group
resource "alicloud_security_group" "group" {
  name        = "sg_sp_critical_business"
  description = "Security group for starter package critical business scenario"
  vpc_id      = alicloud_vpc.vpc.id
}

######## VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = var.name
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "172.16.0.0/24"
  zone_id      = data.alicloud_zones.default.zones[0].id
  vswitch_name = var.name
}

######## ECS
resource "alicloud_instance" "instance" {
  security_groups = alicloud_security_group.group.*.id

  # series III
  instance_type              = "ecs.c6e.xlarge"
  system_disk_category       = "cloud_essd"
  system_disk_name           = "critical_business_system_disk_name"
  system_disk_description    = "critical_business_system_disk_description"
  image_id                   = "centos_8_2_x64_20G_alibase_20201120.vhd"
  instance_name              = "critical_business"
  instance_charge_type       = "PostPaid"
  vswitch_id                 = alicloud_vswitch.vswitch.id
  internet_max_bandwidth_out = 10
  data_disks {
    name        = "disk2"
    size        = 50
    category    = "cloud_essd"
    description = "disk2"
    # encrypted   = true
    # kms_key_id  = alicloud_kms_key.key.id
  }
}

######## Redis
variable "redis_name" {
  default = "redis"
}

variable "creation" {
  default = "KVStore"
}

data "alicloud_zones" "default" {
  available_resource_creation = var.creation
}

resource "alicloud_kvstore_instance" "example" {
  db_instance_name  = "tf-critical-business"
  vswitch_id        = alicloud_vswitch.vswitch.id
  security_group_id = alicloud_security_group.group.id
  instance_type     = "Redis"
  engine_version    = "5.0"
  config = {
    appendonly             = "yes",
    lazyfree-lazy-eviction = "yes",
  }
  tags = {
    Created = "TF",
    For     = "Test",
  }
  resource_group_id = "rg-123456"
  zone_id           = data.alicloud_zones.default.zones[0].id
  instance_class    = "redis.amber.logic.sharding.2g.4db.0rodb.12proxy.multithread"
}

resource "alicloud_kvstore_account" "example" {
  account_name     = "test_redis"
  account_password = "N1cetest"
  instance_id      = alicloud_kvstore_instance.example.id
}

######## PolarDB
resource "alicloud_polardb_cluster" "cluster" {
  db_type       = "MySQL"
  db_version    = "8.0"
  db_node_class = "polar.mysql.x4.large"
  pay_type      = "PostPaid"
  vswitch_id    = alicloud_vswitch.vswitch.id
  description   = "PolarDB MySQL for critical business"
}

resource "alicloud_polardb_account" "account" {
  db_cluster_id       = alicloud_polardb_cluster.cluster.id
  account_name        = "test_polardb"
  account_password    = "N1cetest"
  account_description = "Critical business"
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

######## MongoDB
variable "shard" {
  default = {
    node_class   = "dds.shard.mid"
    node_storage = 10
  }
}

variable "mongo" {
  default = {
    node_class = "dds.mongos.large"
  }
}

resource "alicloud_mongodb_sharding_instance" "foo" {
  zone_id        = data.alicloud_zones.default.zones[0].id
  vswitch_id     = alicloud_vswitch.vswitch.id
  engine_version = "4.2"
  name           = "MongoDB for critical business"
  dynamic "shard_list" {
    for_each = [var.shard]
    content {
      node_class   = shard_list.value.node_class
      node_storage = shard_list.value.node_storage
    }
  }
  dynamic "shard_list" {
    for_each = [var.shard]
    content {
      node_class   = shard_list.value.node_class
      node_storage = shard_list.value.node_storage
    }
  }
  dynamic "mongo_list" {
    for_each = [var.mongo]
    content {
      node_class = mongo_list.value.node_class
    }
  }
  dynamic "mongo_list" {
    for_each = [var.mongo]
    content {
      node_class = mongo_list.value.node_class
    }
  }
}