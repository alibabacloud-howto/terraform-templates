# Terraform script for Starter Package on Alibaba Cloud - Light application scenario
This terraform script will pull up ECS, RDS MySQL and Redis for light application scenario such as foreign trade.

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/starter-package/light-application/archi-light-app.png)

The cloud resources included:
- ECS -- 1C2G 2M, Entry Level (Shared), ecs.t5-lc1m2.small, 20GB cloud disk, CentOS 8.2 x64
- Redis -- 1G, 5.0, Community Edition, Standard, Master-Replica, 1G (master-replica), redis.master.small.default
- RDS -- 1C2G MySQL 8.0, Basic, General-purpose (Entry Level), mysql.n2.small.1, 20GB ESSD