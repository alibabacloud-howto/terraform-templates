### Overview

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-sqlserver-ro/images/archi.png)

### Use Terraform to provision ECS and RDS SQL Server database (Primary + Read-Only) on Alibaba Cloud

If you are the 1st time to use Terraform, please refer to [https://github.com/alibabacloud-howto/terraform-templates](https://github.com/alibabacloud-howto/terraform-templates) to learn how to install and use the Terraform on different operating systems.

Run the [terraform script](https://github.com/alibabacloud-howto/terraform-templates/blob/master/terraform-alicloud-db-samples/rds-sqlserver-ro/main.tf) to initialize the resources. Please specify the necessary information and region to deploy.

![image.png](https://github.com/alibabacloud-howto/solution-applicationstack-parse/raw/main/parse-server-mongodb/images/tf-parms.png)

After the Terraform script execution finished, the ECS instance and RDS for SQL Server information are listed as below.

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-sqlserver-ro/images/tf-done.png)

### Execute the commands to install SQL Server command line tool.

```
curl https://packages.microsoft.com/config/ubuntu/19.10/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt update
sudo apt install mssql-tools -y

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
```

### Using the command ``sqlcmd`` to connect to the SQL Server primary instance.

```
sqlcmd -S <SQL_SERVER_PRIMARY_CONNECTION_STRING>,<SQL_SERVER_PRIMARY_CONNECTION_PORT> -U <USER_NAME> -P '<PASSWORD>' -d <DATABASE_NAME>
```

Please replace the placeholders of the parameters, such as,

```
sqlcmd -S rm-3ns02f8l01hszpg6w.sqlserver.rds.aliyuncs.com,1433 -U test_sqlserver -P 'N1cetest' -d test_database
```

Then execute the SQL commands as below to CREATE TABLE, INSERT and SELECT against the SQL Server primary connection to the primary instance.

```
select @@version
go

Select Name FROM SysObjects Where XType='U' ORDER BY Name
go

DROP TABLE IF EXISTS Departments
CREATE TABLE Departments (DepartmentId   int PRIMARY KEY, DepartmentName varchar(20))
INSERT INTO Departments VALUES (1, 'Mechanical') 
INSERT INTO Departments VALUES (2, 'Chemical') 
INSERT INTO Departments VALUES (3, 'Electronic') 
INSERT INTO Departments VALUES (4, 'Textile') 
INSERT INTO Departments VALUES (5, 'Civil')
go

SELECT * FROM Departments
go
```

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-sqlserver-ro/images/sqlcmd-1.png)

### Using the command ``sqlcmd`` to connect to the SQL Server read-only instance.

```
sqlcmd -S <SQL_SERVER_READONLY_CONNECTION_STRING>,<SQL_SERVER_READONLY_CONNECTION_PORT> -U <USER_NAME> -P '<PASSWORD>' -d <DATABASE_NAME>
```

Please replace the placeholders of the parameters, such as,

```
sqlcmd -S rr-3nsa4tx7i04xb1w00.sqlserver.rds.aliyuncs.com,1433 -U test_sqlserver -P 'N1cetest' -d test_database
```

Then execute the SQL commands as below. We can see that INSERT is not allowed on the read-only connection string to the read-only instance.

```
INSERT INTO Departments VALUES (5, 'Civil')
go

SELECT * FROM Departments
go
```

![image.png](https://github.com/alibabacloud-howto/terraform-templates/raw/master/terraform-alicloud-db-samples/rds-sqlserver-ro/images/sqlcmd-2.png)