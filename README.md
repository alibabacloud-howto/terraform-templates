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
# How to get my cloud Access Key and Secret Key?
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
# How to get the ID of Alibaba Cloud regions?
Please refer to: https://www.alibabacloud.com/help/doc-detail/40654.htm

---
# Reference of Alibaba Cloud Database Instance Specification

| Database Service | Reference URL |
| :------: | :---------: |
| RDS primary instance | https://www.alibabacloud.com/help/doc-detail/26312.htm |
| RDS read only instance | https://www.alibabacloud.com/help/doc-detail/145759.htm |
| PolarDB MySQL | https://www.alibabacloud.com/help/doc-detail/102542.htm |
| PolarDB PostgreSQL | https://www.alibabacloud.com/help/doc-detail/173282.htm |
| PolarDB O (Oracle Compatible Edition) | https://www.alibabacloud.com/help/doc-detail/173281.htm |
| MongoDB instance | https://www.alibabacloud.com/help/doc-detail/57141.htm |
| HBase instance | https://www.alibabacloud.com/help/doc-detail/53532.htm |
| Redis instance | https://www.alibabacloud.com/help/doc-detail/26350.htm |

