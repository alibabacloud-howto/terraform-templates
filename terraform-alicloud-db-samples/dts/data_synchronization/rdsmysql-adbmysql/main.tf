provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = var.region
}

variable "region" {
  default = "ap-northeast-1"
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
  name        = "sg_dts_test"
  description = "Security group for DTS test"
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
  system_disk_name           = "dts_demo"
  system_disk_size           = 40
  system_disk_description    = "dts_demo_disk"
  image_id                   = "centos_8_4_x64_20G_alibase_20211027.vhd"
  instance_name              = "dts_demo"
  password                   = "N1cetest" ## Please change accordingly
  instance_charge_type       = "PostPaid"
  vswitch_id                 = alicloud_vswitch.default.id
  internet_max_bandwidth_out = 5
  internet_charge_type       = "PayByTraffic"
}

## RDS MySQL Source
resource "alicloud_db_instance" "source" {
  engine           = "MySQL"
  engine_version   = "8.0"
  instance_type    = "rds.mysql.s1.small"
  instance_storage = "10"
  vswitch_id       = alicloud_vswitch.default.id
  instance_name    = "rds-mysql-source"
  security_ips     = [alicloud_vswitch.default.cidr_block]
}

resource "alicloud_db_database" "source_db" {
  instance_id = alicloud_db_instance.source.id
  name        = "test_database"
}

resource "alicloud_rds_account" "source_account" {
  db_instance_id   = alicloud_db_instance.source.id
  account_name     = "test_mysql"
  account_password = "N1cetest"
}

resource "alicloud_db_account_privilege" "source_privilege" {
  instance_id  = alicloud_db_instance.source.id
  account_name = alicloud_rds_account.source_account.name
  privilege    = "ReadWrite"
  db_names     = alicloud_db_database.source_db.*.name
}

resource "alicloud_db_connection" "internet" {
  instance_id = alicloud_db_instance.source.id
}

## AnalyticDB MySQL Target
resource "alicloud_adb_db_cluster" "target" {
  db_cluster_category = "MixedStorage"
  compute_resource    = "32Core128GB"
  # elastic_io_resource = "2"
  mode               = "flexible"
  db_cluster_version = "3.0"
  payment_type       = "PayAsYouGo"
  vswitch_id         = alicloud_vswitch.default.id
  description        = "AnalyticDB in elastic mode."
  maintain_time      = "23:00Z-00:00Z"
  security_ips       = [alicloud_vswitch.default.cidr_block]
}

resource "alicloud_adb_account" "account" {
  db_cluster_id       = alicloud_adb_db_cluster.target.id
  account_name        = "test_adb"
  account_password    = "N1cetest"
  account_description = "AnalyticDB MySQL as DTS Source"
}

## DTS Data Synchronization
resource "alicloud_dts_synchronization_instance" "default" {
  payment_type                     = "PayAsYouGo"
  source_endpoint_engine_name      = "MySQL"
  source_endpoint_region           = var.region
  destination_endpoint_engine_name = "ADB30"
  destination_endpoint_region      = var.region
  instance_class                   = "small"
  sync_architecture                = "oneway"
}

resource "alicloud_dts_synchronization_job" "default" {
  dts_instance_id                    = alicloud_dts_synchronization_instance.default.id
  dts_job_name                       = "tf-rdsmysql-adbmysql"
  source_endpoint_instance_type      = "RDS"
  source_endpoint_instance_id        = alicloud_db_instance.source.id
  source_endpoint_engine_name        = "MySQL"
  source_endpoint_region             = var.region
  source_endpoint_database_name      = "test_database"
  source_endpoint_user_name          = alicloud_rds_account.source_account.account_name
  source_endpoint_password           = alicloud_rds_account.source_account.account_password
  destination_endpoint_instance_type = "ads"
  destination_endpoint_instance_id   = alicloud_adb_db_cluster.target.id
  destination_endpoint_engine_name   = "ADB30"
  destination_endpoint_region        = var.region
  destination_endpoint_database_name = "test_database"
  destination_endpoint_user_name     = alicloud_adb_account.account.account_name
  destination_endpoint_password      = alicloud_adb_account.account.account_password
  db_list = jsonencode(
    {
      "test_database" : {
        "name" : "test_database",
        "all" : false,
        "Table" : {
          "t_order" : {
            "all" : true,
            "name" : "t_order",
            "part_key" : "order_id",
            "primary_key" : "order_id",
            "type" : "partition"
          }
        }
      }
    }
  )
  structure_initialization = "true"
  data_initialization      = "true"
  data_synchronization     = "true"
  status                   = "Synchronizing"
}

##### Provisioner to setup database
## Step 1: load SQL file and demo program file to ECS
## Step 2: install MySQL client, Python and Python MySQL connector on ECS
## Step 3: connect to RDS MySQL and execute the SQL file to create table "t_order" as the DTS source table
resource "null_resource" "setup_db" {
  provisioner "file" {
    source      = "setup_source_rdsmysql.sql"
    destination = "/root/setup_source_rdsmysql.sql"

    connection {
      type     = "ssh"
      user     = "root"
      password = alicloud_instance.instance.password
      host     = alicloud_instance.instance.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "yum install -y mysql.x86_64",
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
      "mysql -u ${alicloud_rds_account.source_account.account_name} -p${alicloud_rds_account.source_account.account_password} -h ${alicloud_db_instance.source.connection_string} ${alicloud_db_database.source_db.name} < /root/setup_source_rdsmysql.sql"
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

######### Output: DTS task ID
output "dts_id" {
  value = alicloud_dts_synchronization_instance.default.id
}

######### Output: RDS MySQL connection URL
output "rds_mysql_connection_url" {
  value = alicloud_db_instance.source.connection_string
}

######### Output: AnalyticDB MySQL connection URL
output "analyticdb_mysql_connection_url" {
  value = alicloud_adb_db_cluster.target.connection_string
}
