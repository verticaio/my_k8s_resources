## Kubernetes redis cluster installation.
```
kubectl apply -f  redis-conf.yaml
kubectl apply -f  redis-storage.yaml
kubectl apply -f  redis-pvc.yml
kubectl apply -f redis-sts_prod.yaml
kubectl apply -f redis-svc.yaml
```