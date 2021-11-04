# terraform-templates
Terraform samples and templates for Alibaba Cloud product, services and solutions.

---
# Terraform Getting Started
If you are the 1st time using Terraform, please download Terraform from here: [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html).

For different operating system, please refer to the following sections accordingly.

## How to install Terraform on Windows?
Please visit: [https://www.youtube.com/watch?v=ljYzclmsvF4](https://www.youtube.com/watch?v=ljYzclmsvF4)

## How to install Terraform on Linux?
Please visit: [https://www.youtube.com/watch?v=fgSON_ILnLA](https://www.youtube.com/watch?v=NncNOkgsKMM)

## How to install Terraform on Mac OS?
Please visit: [https://www.youtube.com/watch?v=q4WNdNtsuyE](https://www.youtube.com/watch?v=q4WNdNtsuyE)

---
## How to get my cloud Access Key and Secret Key?
Since you need ```Access Key``` and ```Secret Key``` in Terraform to interact with Alibaba Cloud services, such as in the Terraform script ```main.tf```, you may need to 
fill in with Access Key and Secret Key of your Alibaba Cloud account. 

```
provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}
```

If you want to know how to get your Alibaba Cloud account Access Key and Secret Key, please refer to: https://www.youtube.com/watch?v=O0X02sPwHL8.

---
## How to get the ID of Alibaba Cloud regions?
Please refer to: https://www.alibabacloud.com/help/doc-detail/40654.htm

---
## Reference of Alibaba Cloud Database Instance Specification

| Database Service | Reference URL |
| :------: | :---------: |
| RDS primary instance | https://www.alibabacloud.com/help/doc-detail/26312.htm |
| RDS read only instance | https://www.alibabacloud.com/help/doc-detail/145759.htm |
| PolarDB MySQL | https://www.alibabacloud.com/help/doc-detail/102542.htm |
| PolarDB PostgreSQL | https://www.alibabacloud.com/help/doc-detail/173282.htm |
| PolarDB O (Oracle Compatible Edition) | https://www.alibabacloud.com/help/doc-detail/173281.htm |
| Redis instance | https://www.alibabacloud.com/help/doc-detail/26350.htm |
| MongoDB instance | https://www.alibabacloud.com/help/doc-detail/57141.htm |
| HBase instance | https://www.alibabacloud.com/help/doc-detail/53532.htm |
| TSDB/InfluxDB instance | [Reference on Terraform document](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/tsdb_instance#influxdata.n1.mxlarge) |

---
## Terraform Examples for Alibaba Cloud Database

| Database Service | Reference URL |
| :------: | :---------: |
| [RDS MySQL](https://www.alibabacloud.com/product/apsaradb-for-rds-mysql) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-mysql-clouddisk/main.tf |
| [RDS MySQL (Primary Instance + Read Only Instance)](https://www.alibabacloud.com/product/apsaradb-for-rds-mysql) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-mysql-ro-clouddisk/main.tf |
| [RDS PostgreSQL](https://www.alibabacloud.com/product/apsaradb-for-rds-postgresql) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-postgresql/main.tf |
| [RDS SQL Server](https://www.alibabacloud.com/product/apsaradb-for-rds-sql-server) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-sqlserver/main.tf |
| [PolarDB MySQL](https://www.alibabacloud.com/product/polardb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/polardb-mysql/main.tf |
| [PolarDB PostgreSQL](https://www.alibabacloud.com/product/polardb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/polardb-postgresql/main.tf |
| [PolarDB O(Oracle Compatible Edition)](https://www.alibabacloud.com/product/polardb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/polardb-oracle/main.tf |
| [AnalyticDB MySQL (Elastic Mode)](https://www.alibabacloud.com/product/analyticdb-for-mysql) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/analyticdb-mysql/elastic-mode/main.tf |
| [ClickHouse](https://www.alibabacloud.com/product/clickhouse) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/clickhouse/main.tf |
| [Redis](https://www.alibabacloud.com/product/apsaradb-for-redis) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/redis/main.tf |
| [MongoDB (Replica Set)](https://www.alibabacloud.com/product/apsaradb-for-mongodb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/mongodb/main.tf |
| [MongoDB (Sharding Cluster)](https://www.alibabacloud.com/product/apsaradb-for-mongodb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/mongodb-shard/main.tf |
| [HBase](https://www.alibabacloud.com/product/hbase) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/hbase/main.tf |
| [InfluxDB](https://www.alibabacloud.com/product/hitsdb_influxdb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/influxdb/main.tf |
| [TSDB](https://www.alibabacloud.com/product/hitsdb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/tsdb/main.tf |

---
## Example Solutions with Terraform on Alibaba Cloud
Solution projects: https://github.com/alibabacloud-howto/database