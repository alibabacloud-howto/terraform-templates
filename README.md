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

Since you need Access Key and Secret Key in Terraform to interact with Alibaba Cloud services, such as in the Terraform script ```main.tf```, you may need to 
fill in with Access Key and Secret Key of your Alibaba Cloud account. 

```
provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "ap-southeast-1"
}
```

If you want to know how to get your Alibaba Cloud account Access Key and Secret Key, please refer to: https://www.youtube.com/watch?v=O0X02sPwHL8.