provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = var.region
}

variable "region" {
  default = "ap-southeast-5"
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
  security_groups = alicloud_security_group.group.*.id

  instance_type              = "ecs.c5.large" # 2core 4GB
  system_disk_category       = "cloud_ssd"
  system_disk_name           = "remote_exec_adbpg"
  system_disk_size           = 40
  system_disk_description    = "remote_exec_adbpg_disk"
  image_id                   = "centos_8_4_x64_20G_alibase_20211027.vhd"
  instance_name              = "remote_exec_adbpg"
  password                   = "N1cetest" ## Please change accordingly
  instance_charge_type       = "PostPaid"
  vswitch_id                 = alicloud_vswitch.default.id
  internet_max_bandwidth_out = 2
  internet_charge_type       = "PayByTraffic"
}

## PolarDB MySQL as source
resource "alicloud_polardb_cluster" "source" {
  db_type       = "MySQL"
  db_version    = "8.0"
  db_node_class = "polar.mysql.g2.medium"
  pay_type      = "PostPaid"
  vswitch_id    = alicloud_vswitch.default.id
  description   = "PolarDB MySQL as DTS Source"
  parameters {
    name  = "loose_polar_log_bin"
    value = "ON"
  }
}

resource "alicloud_polardb_account" "source_account" {
  db_cluster_id       = alicloud_polardb_cluster.source.id
  account_name        = "test_polardb"
  account_password    = "N1cetest"
  account_description = "PolarDB MySQL as DTS Source"
}

resource "alicloud_polardb_database" "source_db" {
  db_cluster_id = alicloud_polardb_cluster.source.id
  db_name       = "test_database"
}

resource "alicloud_polardb_account_privilege" "source_privilege" {
  db_cluster_id     = alicloud_polardb_cluster.source.id
  account_name      = alicloud_polardb_account.source_account.account_name
  account_privilege = "ReadWrite"
  db_names          = [alicloud_polardb_database.source_db.db_name]
}

## AnalyticDB PostgreSQL as target
resource "alicloud_gpdb_elastic_instance" "target" {
  engine                  = "gpdb"
  engine_version          = "6.0"
  seg_storage_type        = "cloud_essd"
  seg_node_num            = 4
  storage_size            = 50
  instance_spec           = "2C16G"
  db_instance_description = "Created by terraform"
  instance_network_type   = "VPC"
  payment_type            = "PayAsYouGo"
  vswitch_id              = alicloud_vswitch.default.id
  security_ip_list        = [alicloud_vswitch.default.cidr_block]
}

resource "alicloud_gpdb_account" "target_account" {
  db_instance_id      = alicloud_gpdb_elastic_instance.target.id
  account_name        = "test_adb"
  account_password    = "N1cetest"
  account_description = "Terraform_demo"
}

## DTS Data Synchronization
resource "alicloud_dts_synchronization_instance" "default" {
  payment_type                     = "PayAsYouGo"
  source_endpoint_engine_name      = "PolarDB"
  source_endpoint_region           = var.region
  destination_endpoint_engine_name = "Greenplum"
  destination_endpoint_region      = var.region
  instance_class                   = "small"
  sync_architecture                = "oneway"
}

resource "alicloud_dts_synchronization_job" "default" {
  dts_instance_id                    = alicloud_dts_synchronization_instance.default.id
  dts_job_name                       = "tf-polardbm-adbpg"
  source_endpoint_instance_type      = "PolarDB"
  source_endpoint_instance_id        = alicloud_polardb_cluster.source.id
  source_endpoint_engine_name        = "PolarDB"
  source_endpoint_region             = var.region
  source_endpoint_database_name      = alicloud_polardb_database.source_db.db_name
  source_endpoint_user_name          = alicloud_polardb_account.source_account.account_name
  source_endpoint_password           = alicloud_polardb_account.source_account.account_password
  destination_endpoint_instance_type = "GREENPLUM"
  destination_endpoint_instance_id   = alicloud_gpdb_elastic_instance.target.id
  destination_endpoint_engine_name   = "GREENPLUM"
  destination_endpoint_region        = var.region
  destination_endpoint_database_name = "test_database"
  destination_endpoint_user_name     = alicloud_gpdb_account.target_account.account_name
  destination_endpoint_password      = alicloud_gpdb_account.target_account.account_password
  db_list = jsonencode(
    { "test_database" : {
      "name" : "test_database",
      "all" : false,
      "Table" : {
        "t_order" : {
          "all" : true,
          "name" : "t_order",
          "primary_key" : "order_id",
          "type" : "partition"
        }
      }
    } }
  )
  structure_initialization = "true"
  data_initialization      = "true"
  data_synchronization     = "true"
  status                   = "Synchronizing"
}

##### Provisioner to setup database
## Step 1: load SQL files to ECS
## Step 2: install MySQL and ADB PG client on ECS
## Step 3: connect to PolarDB MySQL and execute the SQL file to create table "t_order" as the DTS target table
## Step 4: connect to ADB PG and execute the SQL file to create database "test_database" as the DTS target database
resource "null_resource" "setup_db" {
  provisioner "file" {
    source      = "setup_adbpg.sql"
    destination = "/root/setup_adbpg.sql"

    connection {
      type     = "ssh"
      user     = "root"
      password = alicloud_instance.instance.password
      host     = alicloud_instance.instance.public_ip
    }
  }

  provisioner "file" {
    source      = "setup_polardbm.sql"
    destination = "/root/setup_polardbm.sql"

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
      "cd ~",
      "wget http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/compat-openssl10-1.0.2o-3.el8.x86_64.rpm",
      "rpm -i compat-openssl10-1.0.2o-3.el8.x86_64.rpm",
      "wget http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/181125/cn_zh/1598426198114/adbpg_client_package.el7.x86_64.tar.gz",
      "tar -xzvf adbpg_client_package.el7.x86_64.tar.gz",
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
      "mysql -u ${alicloud_polardb_account.source_account.account_name} -p${alicloud_polardb_account.source_account.account_password} -h ${alicloud_polardb_cluster.source.connection_string} ${alicloud_polardb_database.source_db.db_name} < /root/setup_polardbm.sql"
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
      "PGPASSWORD=${alicloud_gpdb_account.target_account.account_password} /root/adbpg_client_package/bin/psql -h${alicloud_gpdb_elastic_instance.target.connection_string} -U${alicloud_gpdb_account.target_account.account_name} adbpg -f /root/setup_adbpg.sql"
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

######### Output: PolarDB MySQL Connection String
output "polardb_mysql_url" {
  value = alicloud_polardb_cluster.source.connection_string
}

######### Output: ADB PG Connection String
output "abdpg_url" {
  value = alicloud_gpdb_elastic_instance.target.connection_string
}
