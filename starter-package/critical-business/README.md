# Terraform script for Starter Package on Alibaba Cloud - Critical business scenario
This terraform script will pull up ECS, PolarDB MySQL, Redis and MongoDB for critical business scenario such as gaming service.

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/starter-package/critical-business/archi-critical-business.png)

The cloud resources included:
- ECS -- 4C8G 10M, Enhanced, ecs.c6e.xlarge, 50GB ESSD, CentOS 8.2 x64
- Redis -- 8G, 5.0, Tair, Enhanced Performance, Cluster, 4 Shards, Master-Replica, 8G performance-enhanced (4 shards), redis.amber.logic.sharding.2g.4db.0rodb.12proxy.multithread
- PolarDB MySQL -- 4C16G Dedicated cluster MySQL 8.0, polar.mysql.x4.large
- MongoDB -- 4.2, Sharding cluster
  - Mongos Specification: 4C8G, dds.mongos.large, Quantity: 2;
  - Shard Type: 1C2G, dds.shard.mid, Storage Capacity: 10GB, Quantity:2;
  - Config Server Type: 1C2G, dds.cs.mid, Config Server: 20GB