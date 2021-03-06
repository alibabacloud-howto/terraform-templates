provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-hongkong"
}

variable "mongodb_shard_name" {
  default = "mongodb-shard"
}

variable "shard" {
  default = {
    node_class   = "dds.shard.mid"
    node_storage = 10
  }
}

variable "mongo" {
  default = {
    node_class = "dds.mongos.mid"
  }
}

variable "creation" {
  default = "MongoDB"
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

resource "alicloud_mongodb_sharding_instance" "foo" {
  zone_id        = data.alicloud_zones.default.zones[0].id
  vswitch_id     = alicloud_vswitch.default.id
  engine_version = "4.2"
  name           = var.mongodb_shard_name
  dynamic "shard_list" {
    for_each = [var.shard]
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      node_class   = shard_list.value.node_class
      node_storage = shard_list.value.node_storage
    }
  }
  dynamic "shard_list" {
    for_each = [var.shard]
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      node_class   = shard_list.value.node_class
      node_storage = shard_list.value.node_storage
    }
  }
  dynamic "mongo_list" {
    for_each = [var.mongo]
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      node_class = mongo_list.value.node_class
    }
  }
  dynamic "mongo_list" {
    for_each = [var.mongo]
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      node_class = mongo_list.value.node_class
    }
  }
}

# resource "alicloud_mongodb_account" "foo" {
#   account_name        = "root"
#   account_password    = "N1cetest"
#   instance_id         = alicloud_mongodb_sharding_instance.foo.id
#   account_description = "example_value"
# }

######### Output: MongoDB Connection String
output "mongodb_sharding_instance_id" {
  value = alicloud_mongodb_sharding_instance.foo.id
}

output "mongodb_config_server_list" {
  value = alicloud_mongodb_sharding_instance.foo.config_server_list
}

