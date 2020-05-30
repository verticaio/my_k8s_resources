apply blue app,service and request it 
$ EXTERNAL_IP=$(kubectl get svc nginx -o jsonpath="{.status.loadBalancer.ingress[*].ip}")
$ curl -s http://$EXTERNAL_IP/version | grep nginx

Apply green deployment and new version 
Daha sonra ikinci svc update ederek sadece selectoru yeni  appa deyisirem ve servicen update edirem ve requestler ona gelir.

