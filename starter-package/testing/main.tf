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
  name        = "sg_sp_testing"
  description = "Security group for starter package testing scenario"
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
  instance_type              = "ecs.t5-lc1m1.small"
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = "testing_system_disk_name"
  system_disk_description    = "testing_system_disk_description"
  image_id                   = "centos_8_2_x64_20G_alibase_20201120.vhd"
  instance_name              = "testing"
  instance_charge_type       = "PostPaid"
  vswitch_id                 = alicloud_vswitch.vswitch.id
  internet_max_bandwidth_out = 10
  data_disks {
    name        = "disk2"
    size        = 20
    category    = "cloud_efficiency"
    description = "disk2"
    # encrypted   = true
    # kms_key_id  = alicloud_kms_key.key.id
  }
}

######## RDS MySQL
variable "rds_mysql_name" {
  default = "rds_mysql"
}

variable "creation" {
  default = "Rds"
}

data "alicloud_zones" "default" {
  available_resource_creation = var.creation
}

resource "alicloud_db_instance" "instance" {
  engine                   = "MySQL"
  engine_version           = "8.0"
  instance_type            = "mysql.n1.micro.1"
  instance_storage         = "20"
  db_instance_storage_type = "cloud_essd"
  instance_charge_type     = "Postpaid"
  vswitch_id               = alicloud_vswitch.vswitch.id
  security_group_ids       = [alicloud_security_group.group.id]
  instance_name            = var.rds_mysql_name
}

resource "alicloud_db_account" "account" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "test_mysql"
  account_password = "N1cetest"
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.instance.id
  name        = "test_mysql"
}

resource "alicloud_db_account_privilege" "privilege" {
  instance_id  = alicloud_db_instance.instance.id
  account_name = alicloud_db_account.account.name
  privilege    = "ReadWrite"
  db_names     = alicloud_db_database.default.*.name
}
