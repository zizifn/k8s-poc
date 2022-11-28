使用 kubectl 直接部署。。

kubectl.exe apply -f .\es-stack.yaml

kubectl.exe delete -f .\es-stack.yaml

kubectl get secret elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode
