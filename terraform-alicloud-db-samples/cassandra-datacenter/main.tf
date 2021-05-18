provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}

variable "cassandra_name" {
  default = "cassandra"
}

# variable "creation" {
#   default = "Cassandra"
# }

data "alicloud_zones" "default" {
  #   available_resource_creation = var.creation
}

resource "alicloud_vpc" "default" {
  name       = "vpc-test"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "dc_1" {
  vpc_id            = alicloud_vpc.default.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = data.alicloud_zones.default.zones[0].id
  name              = "vsw-dc-1"
}

resource "alicloud_vswitch" "dc_2" {
  vpc_id            = alicloud_vpc.default.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = data.alicloud_zones.default.zones[1].id
  name              = "vsw-dc-2"
}

resource "alicloud_cassandra_cluster" "default" {
  cluster_name        = "cassandra-cluster-name-tf"
  data_center_name    = "dc-1"
  auto_renew          = "false"
  instance_type       = "cassandra.c.large"
  major_version       = "3.11"
  node_count          = "2"
  pay_type            = "PayAsYouGo"
  vswitch_id          = alicloud_vswitch.dc_1.id
  disk_size           = "160"
  disk_type           = "cloud_ssd"
  maintain_start_time = "18:00Z"
  maintain_end_time   = "20:00Z"
  ip_white            = "127.0.0.1"
}

resource "alicloud_cassandra_data_center" "default" {
  cluster_id       = alicloud_cassandra_cluster.default.id
  data_center_name = "dc-2"
  auto_renew       = "false"
  instance_type    = "cassandra.c.large"
  node_count       = "2"
  pay_type         = "PayAsYouGo"
  vswitch_id       = alicloud_vswitch.dc_2.id
  disk_size        = "160"
  disk_type        = "cloud_ssd"
}
