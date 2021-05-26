provider "alicloud" {
  ## This is ENTERPRISE ACCOUNT ONLY !!!
  ## Please make sure the account you used is enterprise account !!!

  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}

variable "hbase_name" {
  default = "hbase"
}

variable "creation" {
  default = "HBase"
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
