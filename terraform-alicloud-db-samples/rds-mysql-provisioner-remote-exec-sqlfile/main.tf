provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "cn-hongkong"
}

variable "rds_mysql_name" {
  default = "rds_mysql"
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
  name        = "sg_apache_shardingsphere"
  description = "Security group for apache shardingsphere"
  vpc_id      = alicloud_vpc.default.id
}

resource "alicloud_security_group_rule" "allow_http_3307" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "3307/3307"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_http_8001" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "8001/8001"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_https_443" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
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
  security_groups = alicloud_security_group.group.*.id

  instance_type              = "ecs.c5.large" # 2core 4GB
  system_disk_category       = "cloud_ssd"
  system_disk_name           = "remote_exec_mysql"
  system_disk_size           = 40
  system_disk_description    = "remote_exec_mysql_disk"
  image_id                   = "ubuntu_20_04_x64_20G_alibase_20211027.vhd"
  instance_name              = "remote_exec_mysql"
  password                   = "N1cetest" ## Please change accordingly
  instance_charge_type       = "PostPaid"
  vswitch_id                 = alicloud_vswitch.default.id
  internet_max_bandwidth_out = 2
  internet_charge_type       = "PayByTraffic"
}

######## RDS MySQL
resource "alicloud_db_instance" "instance" {
  engine           = "MySQL"
  engine_version   = "8.0"
  instance_type    = "rds.mysql.s1.small"
  instance_storage = "10"
  vswitch_id       = alicloud_vswitch.default.id
  instance_name    = var.rds_mysql_name
  security_ips     = [alicloud_vswitch.default.cidr_block]
}

resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.instance.id
  name        = "test_database"
}

resource "alicloud_rds_account" "super_account" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "super_test_mysql"
  account_password = "N1cetest"
  account_type     = "Super"
}

resource "alicloud_rds_account" "normal_account_1" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "test_mysql_1"
  account_password = "password1"
  account_type     = "Normal"
}

resource "alicloud_rds_account" "normal_account_2" {
  db_instance_id   = alicloud_db_instance.instance.id
  account_name     = "test_mysql_2"
  account_password = "password2"
  account_type     = "Normal"
}

##### Privisioner to setup database
## Step 1: load SQL file to ECS
## Step 2: install MySQL client on ECS
## Step 3: connect to RDS MySQL and execute the SQL file
resource "null_resource" "setup_db" {
  provisioner "file" {
    source      = "setup.sql"
    destination = "/root/setup.sql"

    connection {
      type     = "ssh"
      user     = "root"
      password = alicloud_instance.instance.password
      host     = alicloud_instance.instance.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "apt update && apt -y install mysql-client"
    ]

    connection {
      type     = "ssh"
      user     = "root"
      password = alicloud_instance.instance.password
      host     = alicloud_instance.instance.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "mysql -u ${alicloud_rds_account.super_account.account_name} -p${alicloud_rds_account.super_account.account_password} -h ${alicloud_db_instance.instance.connection_string} -P ${alicloud_db_instance.instance.port} ${alicloud_db_database.default.name} < /root/setup.sql"
    ]

    connection {
      type     = "ssh"
      user     = "root"
      password = alicloud_instance.instance.password
      host     = alicloud_instance.instance.public_ip
    }
  }
}

######### Output: ECS public IP
output "ecs_public_ip" {
  value = alicloud_instance.instance.public_ip
}

######### Output: RDS MySQL Connection String
output "rds_mysql_url" {
  value = alicloud_db_instance.instance.connection_string
}

######### Output: RDS MySQL Connection Port
output "rds_mysql_port" {
  value = alicloud_db_instance.instance.port
}
