provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = var.region
}

variable "region" {
  default = "ap-southeast-5"
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
  source_endpoint_instance_id        = "pc-d9jc957b14p21h940"
  source_endpoint_engine_name        = "PolarDB"
  source_endpoint_region             = var.region
  source_endpoint_database_name      = "test_database"
  source_endpoint_user_name          = "test_polardb"
  source_endpoint_password           = "N1cetest"
  destination_endpoint_instance_type = "GREENPLUM"
  destination_endpoint_instance_id   = "gp-d9j76lbhx6l03804y"
  destination_endpoint_engine_name   = "GREENPLUM"
  destination_endpoint_region        = var.region
  destination_endpoint_database_name = "test_database"
  destination_endpoint_user_name     = "test_adbpg"
  destination_endpoint_password      = "N1cetest"
  db_list                            = <<-EOT
                                        {\"test_database\":{
                                          \"name\":\"test_database\",
                                          \"all\":false,
                                          \"Table\":{
                                            \"t_order\":{
                                              \"all\":true,
                                              \"name\":\"t_order\",
                                              \"primary_key\":\"c1\",
                                              \"type\":\"partition\"
                                            }
                                          }
                                        }}
                                       EOT 
  structure_initialization           = "true"
  data_initialization                = "true"
  data_synchronization               = "true"
  status                             = "Synchronizing"
}
