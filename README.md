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
## How to get the AZ (Availability Zone) ID of Alibaba Cloud Database services?
Using Terraform to obtain available zones for Alibaba Cloud Database products on global regions: https://github.com/alibabacloud-howto/terraform-database-available-zones

---
## Reference of Alibaba Cloud Database Instance Specification

| Database Service | Reference URL |
| :------: | :---------: |
| RDS for MySQL primary instance | https://www.alibabacloud.com/help/doc-detail/276975.htm |
| RDS for MySQL read-only instance | https://www.alibabacloud.com/help/doc-detail/276980.htm |
| RDS for PostgreSQL primary instance | https://www.alibabacloud.com/help/doc-detail/276990.htm |
| RDS for PostgreSQL read-only instance | https://www.alibabacloud.com/help/doc-detail/276992.htm |
| RDS for SQL Server primary instance | https://www.alibabacloud.com/help/doc-detail/276987.htm |
| RDS for SQL Server read-only instance | https://www.alibabacloud.com/help/doc-detail/276988.htm |
| PolarDB for MySQL | https://www.alibabacloud.com/help/doc-detail/102542.htm |
| PolarDB for PostgreSQL | https://www.alibabacloud.com/help/doc-detail/173282.htm |
| PolarDB for Oracle | https://www.alibabacloud.com/help/doc-detail/173281.htm |
| Redis instance | https://www.alibabacloud.com/help/doc-detail/26350.htm |
| MongoDB instance | https://www.alibabacloud.com/help/doc-detail/57141.htm |
| HBase instance | https://www.alibabacloud.com/help/doc-detail/53532.htm |
| TSDB/InfluxDB instance | [Reference on Terraform document](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/tsdb_instance#influxdata.n1.mxlarge) |

---
## Terraform Examples for Alibaba Cloud Database

|  | Database Service | Reference URL |
| :------: | :------ | :--------- |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/mysql-64.png) | [RDS MySQL](https://www.alibabacloud.com/product/apsaradb-for-rds-mysql) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-mysql-clouddisk/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/mysql-64.png) | [RDS MySQL (Primary Instance + Read Only Instance)](https://www.alibabacloud.com/product/apsaradb-for-rds-mysql) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-mysql-ro/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/postgresql-64.png) | [RDS PostgreSQL](https://www.alibabacloud.com/product/apsaradb-for-rds-postgresql) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-postgresql/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/sqlserver-64.png) | [RDS SQL Server](https://www.alibabacloud.com/product/apsaradb-for-rds-sql-server) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-sqlserver/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/polardb-64.png) | [PolarDB for MySQL](https://www.alibabacloud.com/product/polardb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/polardb-mysql/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/polardb-64.png)  | [PolarDB for PostgreSQL](https://www.alibabacloud.com/product/polardb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/polardb-postgresql/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/polardb-64.png) | [PolarDB for Oracle](https://www.alibabacloud.com/product/polardb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/polardb-oracle/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/adb-mysql-64.png) | [AnalyticDB for MySQL (Elastic Mode)](https://www.alibabacloud.com/product/analyticdb-for-mysql) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/analyticdb-mysql/elastic-mode/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/clickhouse-64.png) | [ClickHouse](https://www.alibabacloud.com/product/clickhouse) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/clickhouse/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/redis-64.png) | [Redis](https://www.alibabacloud.com/product/apsaradb-for-redis) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/redis/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/mongodb-64.png) | [MongoDB (Replica Set)](https://www.alibabacloud.com/product/apsaradb-for-mongodb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/mongodb/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/mongodb-64.png) | [MongoDB (Sharding Cluster)](https://www.alibabacloud.com/product/apsaradb-for-mongodb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/mongodb-shard/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/hbase-64.png) | [HBase](https://www.alibabacloud.com/product/hbase) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/hbase/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/tsdb-64.png) | [InfluxDB](https://www.alibabacloud.com/product/hitsdb_influxdb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/influxdb/main.tf |
| ![image.png](https://github.com/alibabacloud-howto/database/raw/main/apsaradb-logos/tsdb-64.png) | [TSDB](https://www.alibabacloud.com/product/hitsdb) | https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/tsdb/main.tf |

---
## Example Solutions with Terraform on Alibaba Cloud
Solution projects: https://github.com/alibabacloud-howto/database