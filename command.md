## port-forward access pods

https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/
```
kubectl port-forward mongo-75f59d57f4-4nd6q 28015(localhost):27017(pod port)
kubectl port-forward svc/mongo-svc 28015(localhost):27017(service port)
```
or

http://localhost:8001/api/v1/namespaces/default/pods/ap123456-docker-hello-world-deployment-59579fdf5c-nzzn4:80/proxy/
## access service
http://localhost:8001/api/v1/namespaces/default/services/ap123456-docker-hello-world-svc:80/proxy/

## terraform
1. terraform apply -target="module.oci-infra"

2. 如果资源不在 terraform 管理，需要 import， 每种资源名字不一样，请参考 https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket#import

# test

 terraform import 'module.k8s-app-hello.kubernetes_service_v1.k8s_svc[\"ap123456\"]' default/ap123456-docker-hello-world-svc