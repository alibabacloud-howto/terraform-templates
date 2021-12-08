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

## ------------------- Your environment parameters
## VPC ID
variable "vpc_id" {
  default = "vpc-xxx"
}

## VSW ID
variable "vswitch_id" {
  default = "vsw-xxx"
}

## PolarDB MySQL as source
variable "polardbm_id" {
  default = "pc-xxx"
}

variable "polardbm_connection_string" {
  default = "pc-xxx.mysql.polardb.ap-southeast-5.rds.aliyuncs.com"
}

variable "polardbm_account_name" {
  default = "test_polardb"
}

variable "polardbm_account_password" {
  default = "N1cetest"
}

## AnalyticDB PostgreSQL as target
variable "adbpg_id" {
  default = "gp-xxx"
}

variable "adbpg_connection_string" {
  default = "gp-xxx-master.gpdbmaster.ap-southeast-5.rds.aliyuncs.com"
}

variable "adbpg_account_name" {
  default = "test_adb"
}

variable "adbpg_account_password" {
  default = "N1cetest"
}
## -------------------

######## Security group
resource "alicloud_security_group" "group" {
  name        = "sg_dts_test"
  description = "Security group for DTS test"
  vpc_id      = var.vpc_id
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
  instance_type              = "ecs.c5.large" # 2core 4GB
  system_disk_category       = "cloud_ssd"
  system_disk_name           = "remote_exec_adbpg"
  system_disk_size           = 40
  system_disk_description    = "remote_exec_adbpg_disk"
  image_id                   = "centos_8_4_x64_20G_alibase_20211027.vhd"
  instance_name              = "remote_exec_adbpg"
  password                   = "N1cetest" ## Please change accordingly
  instance_charge_type       = "PostPaid"
  vswitch_id                 = var.vswitch_id
  internet_max_bandwidth_out = 5
  internet_charge_type       = "PayByTraffic"
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
  source_endpoint_instance_id        = var.polardbm_id
  source_endpoint_engine_name        = "PolarDB"
  source_endpoint_region             = var.region
  source_endpoint_database_name      = "test_database"
  source_endpoint_user_name          = var.polardbm_account_name
  source_endpoint_password           = var.polardbm_account_password
  destination_endpoint_instance_type = "GREENPLUM"
  destination_endpoint_instance_id   = var.adbpg_id
  destination_endpoint_engine_name   = "GREENPLUM"
  destination_endpoint_region        = var.region
  destination_endpoint_database_name = "test_database"
  destination_endpoint_user_name     = var.adbpg_account_name
  destination_endpoint_password      = var.adbpg_account_password
  db_list = jsonencode(
    { "test_database" : {
      "name" : "test_database",
      "all" : false,
      "Table" : {
        "t_order" : {
          "all" : true,
          "name" : "t_order",
          "primary_key" : "order_id",
          "part_key" : "order_id",
          "type" : "partition"
        }
      }
    } }
  )
  structure_initialization = "true"
  data_initialization      = "true"
  data_synchronization     = "true"
  status                   = "Synchronizing"

  depends_on = [
    null_resource.setup_db,
  ]
}

##### Provisioner to setup database
## Step 1: load SQL files to ECS
## Step 2: install MySQL and ADB PG client on ECS
## Step 3: connect to PolarDB MySQL and execute the SQL file to create table "t_order" as the DTS source table
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
      "mysql -u ${var.polardbm_account_name} -p${var.polardbm_account_password} -h ${var.polardbm_connection_string} test_database < /root/setup_polardbm.sql"
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
      "PGPASSWORD=${var.adbpg_account_password} /root/adbpg_client_package/bin/psql -h${var.adbpg_connection_string} -U${var.adbpg_account_name} -f /root/setup_adbpg.sql"
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
