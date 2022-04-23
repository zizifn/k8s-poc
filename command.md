## port-forward access pods

https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/
```
kubectl port-forward mongo-75f59d57f4-4nd6q 28015(localhost):27017(pod port)
kubectl port-forward svc/mongo-svc 28015(localhost):27017(service port)
```

## terraform
1. terraform apply -target="module.oci-infra"

2. 如果资源不在 terraform 管理，需要 import， 每种资源名字不一样，请参考 https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket#import

# test