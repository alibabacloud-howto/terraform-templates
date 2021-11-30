# Setup RDS for PostgreSQL LDAP Authentication with Microsoft AD (Active Directory) Deployed on ECS

You can access the tutorial artifact including deployment script (Terraform) from the github project:
https://github.com/alibabacloud-howto/terraform-templates/tree/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad

More tutorial around Alibaba Cloud Database, please refer to:
[https://github.com/alibabacloud-howto/database](https://github.com/alibabacloud-howto/database)

---
### Overview

Active Directory (AD) is a directory service developed by Microsoft for Windows domain networks. It is included in most Windows Server operating systems as a set of processes and services.

In this solution tutorial, let's see how to deploy and setup Microsoft AD on ECS Windows Server 2016 or later, and setup LDAP Authentication with this AD Domain Service for [RDS for PostgreSQL](https://www.alibabacloud.com/product/apsaradb-for-rds-postgresql) on Alibaba Cloud.

Deployment architecture of this tutorial:

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/archi.png)

---
### Index

- [Step 1. Use Terraform to provision ECS and RDS PostgreSQL database on Alibaba Cloud]()
- [Step 2. Setup AD DS and LDAP user for RDS PostgreSQL database authentication]()
- [Step 3. Configure AD DS information on RDS PostgreSQL]()
- [Step 4. Verify the AD LDAP authentication for RDS PostgreSQL]()

---
### Step 1. Use Terraform to provision ECS and RDS PostgreSQL database on Alibaba Cloud

If you are the 1st time to use Terraform, please refer to [https://github.com/alibabacloud-howto/terraform-templates](https://github.com/alibabacloud-howto/terraform-templates) to learn how to install and use the Terraform on different operating systems.

Run the [terraform script](https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/main.tf) to initialize the resources (in this tutorial, we use 1 RDS for PostgreSQL, 1 Windows Server 2019 ECS for AD installation and 1 Ubuntu ECS for demo database application connecting to RDS PostgreSQL). Please specify the necessary information and region to deploy.

![image.png](https://github.com/alibabacloud-howto/solution-applicationstack-parse/raw/main/parse-server-mongodb/images/tf-parms.png)

After the Terraform script execution finished, the ECS instance and RDS for PostgreSQL information are listed as below.

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/tf-done.png)

- ``ad_ecs_private_ip``: The private IP of the Windows Server ECS with Microsoft AD installation
- ``ad_ecs_public_ip``: The public IP of the Windows Server ECS with Microsoft AD installation
- ``demo_ecs_public_ip``: The public IP of the ECS for demo database application
- ``rds_pg_url``: The RDS for PostgreSQL database connection URL
- ``rds_pg_port``: The RDS for PostgreSQL database service port

---
### Step 2. Setup AD DS and LDAP user for RDS PostgreSQL database authentication

Using Remote desktop to connect to Windows Server ECS. The log on password for user ``administrator`` is ``WindowsN1cetest``, which is predefined in the [terraform script](https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/main.tf).

Follow the screenshots below to setup the Microsoft AD DS on the Windows Server ECS.

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-1.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-2.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-3.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-4.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-5.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-6.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-7.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-8.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-9.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-10.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-11.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-12.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-13.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-14.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-15.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-16.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-17.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-18.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-19.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-20.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-21.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-22.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-23.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-24.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-25.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-26.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-27.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-28.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-29.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-30.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-31.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-32.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-33.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-34.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-35.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-36.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/ecs-ad-37.png)

---
### Step 3. Configure AD DS information on RDS PostgreSQL

Log on to the RDS PostgreSQL web console, then follow the screenshots below to setup the Microsoft AD DS information on RDS PostgreSQL.

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/pg-ad-1.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/pg-ad-2.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/pg-ad-3.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/pg-ad-4.png)

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/pg-ad-5.png)

ldapserver=<ECS AD Server Private IP> ldapbasedn="CN=Users,DC=pgsqldomain,DC=net" ldapbinddn="CN=<DB Admin User Name in AD>,CN=Users,DC=pgsqldomain,DC=net" ldapbindpasswd="<DB Admin User Password in AD>" ldapsearchattribute="sAMAccountName"
ldapserver=192.168.0.35 ldapbasedn="CN=Users,DC=pgsqldomain,DC=net" ldapbinddn="CN=dbadmin,CN=Users,DC=pgsqldomain,DC=net" ldapbindpasswd="N1cetest" ldapsearchattribute="sAMAccountName"

---
### Step 4. Verify the AD LDAP authentication for RDS PostgreSQL

Please log on to ECS with ``<demo_ecs_public_ip>`` and the password is ``N1cetest`` by default, which is preset in the terraform provision script in Step 1. If you've already changed it, please update accordingly.

```bash
ssh root@<demo_ecs_public_ip>
```

psql -h <RDS PostgreSQL Connection URL> -U ldapuser -p 5432 -d postgres
psql -h pgm-3nsl6a419da052iy168210.pg.rds.aliyuncs.com -U ldapuser -p 5432 -d postgres

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-postgresql-ecs-microsoft-ad/images/verify.png)