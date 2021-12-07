### DTS Data Synchronization Channel (One-Way) from PolarDB MySQL to AnalyticDB PostgreSQL

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/dts/data_synchronization/polardbm-adbpg/images/archi.png)

``This is a PolarDB MySQL to AnalyticDB PostgreSQL demo``

When you are using [main.tf](https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/dts/data_synchronization/polardbm-adbpg/main.tf), 
please make sure the following prerequisites,

- Database account and a database named "test_database" has been created on PolarDB MySQL
- Database account has been created on AnalyticDB PostgreSQL
- update the parameters in [main.tf](https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/dts/data_synchronization/polardbm-adbpg/main.tf) according to your VPC, VSwitch, PolarDB MySQL and AnalyticDB PostgreSQL
- make sure the connectivity to PolarDB MySQL and AnalyticDB PostgreSQL from ECS (such as add ``0.0.0.0/0`` to the whitelist of PolarDB MySQL and AnalyticDB PostgreSQL for the demo)