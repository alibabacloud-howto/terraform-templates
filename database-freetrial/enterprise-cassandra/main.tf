provider "alicloud" {
  ## This is ENTERPRISE ACCOUNT ONLY !!!
  ## Please make sure the account you used is enterprise account !!!

  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}

variable "cassandra_name" {
  default = "cassandra"
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
