# oci-poc
设置 oracle cloud 

## Setup Terraform

### Install Terraform

Go to official website.
https://learn.hashicorp.com/collections/terraform/oci-get-started
### Share Terraform State via Terraform Cloud

https://www.terraform.io/cli/cloud

``` hcl
  cloud {
    # 用来同步 terraform state 到cloud 上。
    organization = "zizifn"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      name = "oci-poc"
      # tags = ["networking", "source:cli"]
    }
  }
```
