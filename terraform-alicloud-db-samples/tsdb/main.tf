provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-hongkong"
}

data "alicloud_tsdb_zones" "example" {}

resource "alicloud_vpc" "example" {
  cidr_block = "192.168.0.0/16"
  vpc_name   = "tf-testaccTsdbInstance"
}

resource "alicloud_vswitch" "example" {
  zone_id    = data.alicloud_tsdb_zones.example.ids.0
  cidr_block = "192.168.1.0/24"
  vpc_id     = alicloud_vpc.example.id
}

resource "alicloud_tsdb_instance" "example" {
  payment_type     = "PayAsYouGo"
  vswitch_id       = alicloud_vswitch.example.id
  instance_storage = "50"
  instance_class   = "tsdb.1x.basic"
  engine_type      = "tsdb_tsdb"
  instance_alias   = "tf-testaccTsdbInstance"
}
ß