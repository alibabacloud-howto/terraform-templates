provider "alicloud" {
#   access_key = "${var.access_key}"
#   secret_key = "${var.secret_key}"
  region     = "ap-southeast-1"
}

# RDS MySQL instance name
variable "rds_mysql_name" {
  default = "rds_mysql"
}

# Data source for Alibaba Cloud zones
# here we filter zone by RDS
data "alicloud_zones" "default" {
  available_resource_creation = "Rds"
}

# Resource: VPC
resource "alicloud_vpc" "default" {
  name       = "vpc-test"
  cidr_block = "172.16.0.0/16"
}

# Resource: VSW
resource "alicloud_vswitch" "default" {
  vpc_id            = alicloud_vpc.default.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = data.alicloud_zones.default.zones[0].id
  name              = "vsw-test"
}

# Resource: MongoDB (Replica Set)
resource "alicloud_mongodb_instance" "example" {
  engine_version      = "4.2"
  db_instance_class   = "dds.mongo.mid"
  db_instance_storage = 10
  vswitch_id          = alicloud_vswitch.default.id
}

# Resource: RDS MySQL instance
resource "alicloud_db_instance" "instance" {
  engine           = "MySQL"
  engine_version   = "5.7"
  instance_type    = "rds.mysql.s1.small"
  instance_storage = "10"
  vswitch_id       = alicloud_vswitch.default.id
  instance_name    = var.rds_mysql_name
}

# Resource: RDS MySQL database in the instance
resource "alicloud_db_database" "default" {
  instance_id = alicloud_db_instance.instance.id
  name        = "test_database"
}

# Resource: Redis
resource "alicloud_kvstore_instance" "example" {
  db_instance_name      = "tf-test-basic"
  vswitch_id            = alicloud_vswitch.default.id
  instance_type         = "Redis"
  engine_version        = "4.0"
  config = {
    appendonly = "yes",
    lazyfree-lazy-eviction = "yes",
  }
  tags = {
    Created = "TF",
    For = "Test",
  }
  resource_group_id     = "rg-123456"
  zone_id               = data.alicloud_zones.default.zones[0].id
  instance_class        = "redis.master.micro.default"
}