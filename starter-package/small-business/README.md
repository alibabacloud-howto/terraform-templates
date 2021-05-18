# Terraform script for Starter Package on Alibaba Cloud - Small business scenario
This terraform script will pull up ECS, RDS MySQL and Redis for small business scenario such as official website.

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/starter-package/small-business/archi-small-business.png)

The cloud resources included:
- ECS -- 2C4G 1-5M, Enhanced, ecs.c6e.large, 50GB ESSD, CentOS 8.2 x64
- Redis -- 2G, 5.0, Community Edition, Standard, Master-Replica, 2G (master-replica), redis.master.mid.default
- RDS -- 2C4G MySQL 8.0, High Availability, Dedicated (Enterprise level), mysql.x2.medium.2c, 50GB ESSD
