provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  alias  = "singapore"
  region = "ap-southeast-1"
}

provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  alias  = "sydney"
  region = "ap-southeast-2"
}

# Data source for Alibaba Cloud zones
# here we filter zone by MongoDB
data "alicloud_zones" "singapore" {
  provider                    = "alicloud.singapore"
  available_resource_creation = "MongoDB"
}

# Data source for Alibaba Cloud zones
# here we filter zone by MongoDB
data "alicloud_zones" "sydney" {
  provider                    = "alicloud.sydney"
  available_resource_creation = "MongoDB"
}

# Resource: VPC at Singapore
resource "alicloud_vpc" "vpc_singapore" {
  provider   = "alicloud.singapore"
  name       = "vpc-test"
  cidr_block = "172.16.0.0/16"
}

# Resource: VSW at Singapore
resource "alicloud_vswitch" "vsw_singapore" {
  provider          = "alicloud.singapore"
  vpc_id            = alicloud_vpc.vpc_singapore.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = data.alicloud_zones.singapore.zones[0].id
  name              = "vsw-test"
}

# Resource: VPC at Sydney
resource "alicloud_vpc" "vpc_sydney" {
  provider   = "alicloud.sydney"
  name       = "vpc-test"
  cidr_block = "172.16.0.0/16"
}

# Resource: VSW at Sydney
resource "alicloud_vswitch" "vsw_sydney" {
  provider          = "alicloud.sydney"
  vpc_id            = alicloud_vpc.vpc_sydney.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = data.alicloud_zones.sydney.zones[0].id
  name              = "vsw-test"
}

# Resource: MongoDB (Replica Set) at Singapore
resource "alicloud_mongodb_instance" "mongodb_singapore" {
  provider            = "alicloud.singapore"
  engine_version      = "4.2"
  db_instance_class   = "dds.mongo.mid"
  db_instance_storage = 10
  vswitch_id          = alicloud_vswitch.vsw_singapore.id
}

# Resource: MongoDB (Replica Set) at Sydney
resource "alicloud_mongodb_instance" "mongodb_sydney" {
  provider            = "alicloud.sydney"
  engine_version      = "4.2"
  db_instance_class   = "dds.mongo.mid"
  db_instance_storage = 10
  vswitch_id          = alicloud_vswitch.vsw_sydney.id
}
