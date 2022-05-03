# 基于 OCI 的 kubernetes

使用 Terraform 在 oracle cloud 上搭建 kubernetes。 这是一个基本完备的的 poc。包含基础设施的搭建，已经各个应该如何管理。

示例 app https://k8s.zizi.press/gtw/hello

## 基本信息

项目分为三大部分，

### k8s-infra

这个是为了搭建 K8S 的基础设施。这个一共有三个模块
| Name              | Description                                |
| ----------------- | ------------------------------------------ |
| k8s-vcn-infra     | 包含虚拟网络，子网划分，security group, gateway, route table|
| k8s-cluster     | kubernetes 搭建， load balancer以及security group|
| tags    | 一些用户管理的tag|

### k8s-base-apps

这个搭建基础的 kubernetes 应用。
| Name              | Description                                |
| ----------------- | ------------------------------------------ |
| k8s-cert-manager     | 利用 lets encrypt 实现正式的自动签发 |
| k8s-ingress-nginx     | ingress nginx |
| k8s-auth-token     | 基于rbac 创建 kubernetes account |

### k8s-apps

所有 APP 的所在地
| Name              | Description                                |
| ----------------- | ------------------------------------------ |
| k8s-app-config-map     | 集中所有app的信息，包含，image/port/path. 使用appid 进行统一管理。|
|k8s-app-hello     | 示例app，展示如何使用config，以及 APP 相关的secret |

## GITHUB Action

1. k8s-infra
 用来实现，k8s 基础设施的，创建，销毁，更新的 CI job。
2. k8s-base-apps-update
 用来实现，k8s 基础 APP 的，更新的 CI job。
3. k8s-base-apps-destroy
 用来实现，k8s 基础 APP 的，销毁的 CI job。
4. k8s-apps
 用来实现，Apps，创建，更新，销毁的 CI job。

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
4. terraform state list "module.k8s-app-hello"

## Kubernetes 

### Kubernetes Dashboard

Follow OKE wesite link to get access to Kubernetes

``` bash
kubectl -n kube-system get secret

kubectl -n kube-system describe secret kubernetes-dashboard-token-*

kubectl proxy
```

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login

### get access token

``` bash
TOKENNAME=`kubectl -n kube-system get serviceaccount/kubeconfig-sa -o jsonpath='{.secrets[0].name}'`

kubectl -n kube-system get secret $TOKENNAME -o jsonpath='{.data.token}'

base64 --decode
```
### Add Ingress Controller

https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengsettingupingresscontroller.htm
https://kubernetes.github.io/ingress-nginx/deploy/#oracle-cloud-infrastructure


### troubleshooting
https://kubernetes.github.io/ingress-nginx/troubleshooting/