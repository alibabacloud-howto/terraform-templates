# PolarDB Always Free
Please check here with detailed information:
[https://www.alibabacloud.com/product/databases?J_2463051000&anchor=entryProducts2](https://www.alibabacloud.com/product/databases?J_2463051000&anchor=entryProducts2)

PolarDB is compute and storage decoupled. These Terraform scripts only provision the compute cluster (primary node and read-only node). For 50GB free storage package every month, you can get it here: [https://www.alibabacloud.com/product/polardb?#J_5764451150](https://www.alibabacloud.com/product/polardb?#J_5764451150)

- Always free PolarDB is only available at regions below, please select one of these regions.
  - US(Silicon Valley): us-west-1 
  - Singapore: ap-southeast-1
  - UK(London): eu-west-1
  - Australia(Sydney): ap-southeast-2
  - China(Hong Kong): cn-hongkong

The terraform scripts are:
- [PolarDB MySQL](https://github.com/alibabacloud-howto/terraform-templates/blob/master/database-alwaysfree/polardb-mysql/main.tf)
- [PolarDB PostgreSQL](https://github.com/alibabacloud-howto/terraform-templates/blob/master/database-alwaysfree/polardb-mysql/main.tf)
- [PolarDB Oracle](https://github.com/alibabacloud-howto/terraform-templates/blob/master/database-alwaysfree/polardb-mysql/main.tf)