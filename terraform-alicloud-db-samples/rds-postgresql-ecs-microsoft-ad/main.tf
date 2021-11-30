provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-hongkong"
}

variable "zone_1" {
  default = "cn-hongkong-b"
}

variable "name" {
  default = "microsoft_ad_group"
}

######## Security group
resource "alicloud_security_group" "group" {
  name        = "sg_microsoft_ad_app"
  description = "Security group for Microsoft AD app"
  vpc_id      = alicloud_vpc.vpc.id
}

## Kerberos
resource "alicloud_security_group_rule" "allow_http_88" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "88/88"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## RPC
resource "alicloud_security_group_rule" "allow_http_135" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "135/135"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## LDAP - TCP
resource "alicloud_security_group_rule" "allow_http_389_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "389/389"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## LDAP - UDP
resource "alicloud_security_group_rule" "allow_http_389_udp" {
  type              = "ingress"
  ip_protocol       = "udp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "389/389"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## CIFS
resource "alicloud_security_group_rule" "allow_http_445" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "445/445"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## Global Catalog
resource "alicloud_security_group_rule" "allow_http_3268" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "3268/3268"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## DNS - TCP
resource "alicloud_security_group_rule" "allow_http_53_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "53/53"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## DNS - UDP
resource "alicloud_security_group_rule" "allow_http_53_udp" {
  type              = "ingress"
  ip_protocol       = "udp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "53/53"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## Connection dynamic port range
resource "alicloud_security_group_rule" "allow_http_dynamic_port" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "49152/65535"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## Remote desktop
resource "alicloud_security_group_rule" "allow_rdp_3389" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "3389/3389"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

## SSH
resource "alicloud_security_group_rule" "allow_rdp_22" {
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

######## VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = var.name
  cidr_block = "192.168.0.0/16"
}

resource "alicloud_vswitch" "vswitch_1" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "192.168.0.0/24"
  zone_id      = var.zone_1
  vswitch_name = "vsw_on_zone_1"
}

######## ECS for Microsoft AD Server, Windows Server 2016 or later
resource "alicloud_instance" "instance" {
  security_groups = alicloud_security_group.group.*.id

  instance_type           = "ecs.c6.xlarge" # 4core 8GB
  system_disk_category    = "cloud_ssd"
  system_disk_name        = "microsoft_ad_app_system_disk"
  system_disk_size        = 40
  system_disk_description = "microsoft_ad_app_system_disk"
  image_id                = "win2019_1809_x64_dtc_en-us_40G_container_alibase_20210916.vhd"
  instance_name           = "microsoft_ad_app"
  password                = "WindowsN1cetest" ## Password for user "Administrator", please change accordingly
  instance_charge_type    = "PostPaid"
  vswitch_id              = alicloud_vswitch.vswitch_1.id
}

######## ECS for database client application
resource "alicloud_instance" "demo_instance" {
  security_groups = alicloud_security_group.group.*.id

  instance_type              = "ecs.c6.large"
  system_disk_category       = "cloud_ssd"
  system_disk_name           = "microsoft_ad_app_system_disk"
  system_disk_size           = 40
  system_disk_description    = "microsoft_ad_app_system_disk"
  image_id                   = "ubuntu_20_04_x64_20G_alibase_20211027.vhd"
  instance_name              = "microsoft_ad_app"
  password                   = "N1cetest" ## Password for user "root", Please change accordingly
  instance_charge_type       = "PostPaid"
  vswitch_id                 = alicloud_vswitch.vswitch_1.id
  internet_max_bandwidth_out = 2
  internet_charge_type       = "PayByTraffic"

  ## Provision to install PostgreSQL client on ECS (Ubuntu)
  provisioner "remote-exec" {
    inline = [
      "apt update && apt -y install postgresql-client-common",
      "apt update && apt -y install postgresql-client",
    ]

    connection {
      type     = "ssh"
      user     = "root"
      password = self.password
      host     = self.public_ip
    }
  }
}

######## RDS PostgreSQL
resource "alicloud_db_instance" "microsoft_ad_db" {
  engine             = "PostgreSQL"
  engine_version     = "13.0"
  instance_type      = "pg.n4.medium.1"
  instance_storage   = "20"
  vswitch_id         = alicloud_vswitch.vswitch_1.id
  instance_name      = "microsoft_ad_database"
  security_ips       = [alicloud_vswitch.vswitch_1.cidr_block]
  security_group_ids = [alicloud_security_group.group.id]
}

resource "alicloud_db_database" "microsoft_ad_db" {
  instance_id = alicloud_db_instance.microsoft_ad_db.id
  name        = "test_database"
}

resource "alicloud_rds_account" "microsoft_ad_db_account" {
  db_instance_id   = alicloud_db_instance.microsoft_ad_db.id
  account_name     = "ldapuser" # The accout name is the same with the domain user name in AD
  account_password = "N1cetest" # This password can be different from the one of domain user in AD
  account_type     = "Normal"
}

resource "alicloud_db_account_privilege" "microsoft_ad_db_privilege" {
  instance_id  = alicloud_db_instance.microsoft_ad_db.id
  account_name = alicloud_rds_account.microsoft_ad_db_account.name
  privilege    = "DBOwner"
  db_names     = alicloud_db_database.microsoft_ad_db.*.name
}

######## EIP bind to setup ECS accessing from internet
resource "alicloud_eip" "setup_ecs_access" {
  bandwidth            = "5"
  internet_charge_type = "PayByBandwidth"
}

resource "alicloud_eip_association" "eip_ecs" {
  allocation_id = alicloud_eip.setup_ecs_access.id
  instance_id   = alicloud_instance.instance.id
}

######### Output: EIP of ECS
output "eip_ecs" {
  value = alicloud_eip.setup_ecs_access.ip_address
}

######### Output: ECS public IP
output "demo_ecs_public_ip" {
  value = alicloud_instance.demo_instance.public_ip
}

######### Output: RDS PostgreSQL Connection String
output "rds_pg_url" {
  value = alicloud_db_instance.microsoft_ad_db.connection_string
}

######### Output: RDS PostgreSQL Connection Port
output "rds_pg_port" {
  value = alicloud_db_instance.microsoft_ad_db.port
}
