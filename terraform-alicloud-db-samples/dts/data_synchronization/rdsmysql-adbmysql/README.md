### Quick Path to Build OLTP (RDS MySQL) & OLAP (AnalyticDB MySQL) Cluster with Data Synchronization Channel

You can access the tutorial artifact including deployment script (Terraform), related source code, sample data and instruction guidance from the github project:
https://github.com/alibabacloud-howto/terraform-templates/tree/master/terraform-alicloud-db-samples/dts/data_synchronization/rdsmysql-adbmysql

More tutorial around Alibaba Cloud Database, please refer to:
[https://github.com/alibabacloud-howto/database](https://github.com/alibabacloud-howto/database)

---
### Overview

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/dts/data_synchronization/rdsmysql-adbmysql/images/archi.png)

---
### Index

- [Step 1. Use Terraform to provision services on Alibaba Cloud](https://github.com/alibabacloud-howto/terraform-templates/tree/master/terraform-alicloud-db-samples/dts/data_synchronization/rdsmysql-adbmysql#step-1-use-terraform-to-provision-services-on-alibaba-cloud)
- [Step 2. Run the demo application](https://github.com/alibabacloud-howto/terraform-templates/tree/master/terraform-alicloud-db-samples/dts/data_synchronization/rdsmysql-adbmysql#step-2-run-the-demo-application)

---
### Step 1. Use Terraform to provision services on Alibaba Cloud

If you are the 1st time to use Terraform, please refer to [https://github.com/alibabacloud-howto/terraform-templates](https://github.com/alibabacloud-howto/terraform-templates) to learn how to install and use the Terraform on different operating systems.

Run the [terraform script](https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/dts/data_synchronization/rdsmysql-adbmysql/main.tf) to provision the resources and services.

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/dts/data_synchronization/rdsmysql-adbmysql/images/tf-done.png)

---
### Step 2. Run the demo application

Open 2 CLI windows and log on them to ECS with ``ECS EIP``. By default, the password is ``N1cetest``, which is preset in the terraform provision script in Step 1. If you've already changed it, please update accordingly.

```bash
ssh root@<ECS_EIP>
```

Within one CLI window, edit and configure ``source_rdsmysql_app.py`` with connection to RDS MySQL, then run it as the OLTP demo application.

```
cd ~
vim source_rdsmysql_app.py
```

Then run this Python script as the OLTP demo application, which will be continuously inserting data into the RDS MySQL database.

```
python3 source_rdsmysql_app.py
```

Within another CLI window, edit and configure ``target_adbmysql_app.py`` with connection to AnalyticDB MySQL, then run it as the OLAP demo application.

```
cd ~
vim target_adbmysql_app.py
```

Then run this Python script as the OLAP demo application, which will be continuously querying data from the AnalyticDB MySQL data warehouse.

```
python3 target_adbmysql_app.py
```

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/dts/data_synchronization/rdsmysql-adbmysql/images/demo.png)