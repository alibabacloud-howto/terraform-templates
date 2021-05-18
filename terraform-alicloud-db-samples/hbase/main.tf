provider "alicloud" {
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
  name       = "vpc-test"
  cidr_block = "172.16.0.0/16"
} 

resource "alicloud_vswitch" "default" {
  vpc_id            = alicloud_vpc.default.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = data.alicloud_zones.default.zones[0].id
  name              = "vsw-test"
}

resource "alicloud_hbase_instance" "default" {
  name                   = "tf-hbase-instance-example"
  zone_id                = data.alicloud_zones.default.zones[0].id
  engine                 = "hbase"
  engine_version         = "2.0"
  master_instance_type   = "hbase.sn1.large"
  core_instance_type     = "hbase.sn1.large"
  core_instance_quantity = 2
  core_disk_type         = "cloud_ssd"
  core_disk_size         = 400
  pay_type               = "PostPaid"
  vswitch_id             = alicloud_vswitch.default.id
  cold_storage_size      = 0
  maintain_start_time    = "02:00Z"
  maintain_end_time      = "04:00Z"
  deletion_protection    = true
  immediate_delete_flag  = false
  ip_white               = "127.0.0.1"
}
