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

#### Command
1. terraform state rm [options] ADDRESS...
2. https://www.terraform.io/cli/state/move
3. https://learn.hashicorp.com/tutorials/terraform/move-config

## Kubernetes 

### Kubernetes Dashboard

``` bash
kubectl -n kube-system get secret

kubectl -n kube-system describe secret kubernetes-dashboard-token-*

kubectl proxy
```

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login

### Add Ingress Controller

https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengsettingupingresscontroller.htm
https://kubernetes.github.io/ingress-nginx/deploy/#oracle-cloud-infrastructure