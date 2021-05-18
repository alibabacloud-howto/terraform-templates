# Terraform script for Starter Package on Alibaba Cloud - Testing scenario
This terraform script will pull up ECS and RDS MySQL for very basic testing scenario such as setting up function test environment or simple web blog.

![image.png](https://github.com/alibabacloud-labs/terraform-templates/raw/main/starter-package/testing/archi-testing.png)

The cloud resources included:
- ECS -- 1C1G 1M, Entry Level (Shared), ecs.t5-lc1m1.small, 20GB cloud disk, CentOS 8.2 x64
- RDS -- 1C1G MySQL 8.0, Basic, General-purpose (Entry Level), mysql.n1.micro.1, 20GB ESSD