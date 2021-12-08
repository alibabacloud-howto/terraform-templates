provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-hongkong"
}

variable "rds_sqlserver_name" {
  default = "rds_sqlserver"
}

variable "creation" {
  default = "Rds"
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

######## Security group
resource "alicloud_security_group" "group" {
  name        = "sg_rds_mysql"
  description = "test_sg"
  vpc_id      = alicloud_vpc.default.id
}

resource "alicloud_security_group_rule" "allow_ssh_22" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_all_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

######## ECS
resource "alicloud_instance" "instance" {
  security_groups            = alicloud_security_group.group.*.id
  instance_type              = "ecs.c6.large" # 2core 4GB
  system_disk_category       = "cloud_ssd"
  system_disk_name           = "remote_exec_sqlserver"
  system_disk_size           = 40
  system_disk_description    = "remote_exec_sqlserver_disk"
  image_id                   = "ubuntu_20_04_x64_20G_alibase_20211027.vhd"
  instance_name              = "remote_exec_sqlserver"
  password                   = "N1cetest" ## Please change accordingly
  instance_charge_type       = "PostPaid"
  vswitch_id                 = alicloud_vswitch.default.id
  internet_max_bandwidth_out = 2
  internet_charge_type       = "PayByTraffic"
}

######## RDS SQL Server Primary
resource "alicloud_db_instance" "primary" {
  engine           = "SQLServer"
  engine_version   = "2019_ent"
  instance_type    = "mssql.x4.medium.e2"
  instance_storage = "20"
  vswitch_id       = alicloud_vswitch.default.id
  instance_name    = var.rds_sqlserver_name
  security_ips     = [alicloud_vswitch.default.cidr_block]
}

######## RDS SQL Server Read-Only
resource "alicloud_db_readonly_instance" "ro" {
  master_db_instance_id = alicloud_db_instance.primary.id
  zone_id               = alicloud_db_instance.primary.zone_id
  engine_version        = alicloud_db_instance.primary.engine_version
  instance_type         = "mssql.x4.medium.ro"
  instance_storage      = "20"
  instance_name         = "${var.rds_sqlserver_name}ro"
  vswitch_id            = alicloud_vswitch.default.id
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.primary.id
  name        = "test_database"
}

resource "alicloud_rds_account" "account" {
  db_instance_id   = alicloud_db_instance.primary.id
  account_name     = "test_sqlserver"
  account_password = "N1cetest"
}

resource "alicloud_db_account_privilege" "privilege" {
  instance_id  = alicloud_db_instance.primary.id
  account_name = alicloud_rds_account.account.name
  privilege    = "DBOwner"
  db_names     = alicloud_db_database.default.*.name
}

######### Output: ECS public IP
output "ecs_public_ip" {
  value = alicloud_instance.instance.public_ip
}

######### Output: RDS SQL Server Primary Connection String
output "rds_sqlserver_primary_url" {
  value = alicloud_db_instance.primary.connection_string
}

######### Output: RDS SQL Server Primary Connection Port
output "rds_sqlserver_primary_port" {
  value = alicloud_db_instance.primary.port
}

######### Output: RDS SQL Server Read-Only Connection String
output "rds_sqlserver_readonly_url" {
  value = alicloud_db_readonly_instance.ro.connection_string
}

######### Output: RDS SQL Server Read-Only Connection Port
output "rds_sqlserver_readonly_port" {
  value = alicloud_db_readonly_instance.ro.port
}
