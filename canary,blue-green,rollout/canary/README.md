
```
### Create First namespace
kubectl create ns echo-production

Apply version 1 app and service
kubectl apply -f http-svc.yaml  -n echo-production

Apply first app ingress yaml 
kubectl apply -f http-svc-ing.yaml -n echo-production

Test
curl -H "Host: echo.com" http://10.0.82.44:30080
 
Create Canary Namespace
kubectl create ns echo-canary

Apply canary apps
kubectl apply -f http-svc.yaml -n echo-canary

Apply canary option
kubectl apply -f http-svc-ing-canary.yaml  -n echo-canary

Yeni bu yeni virtualhost yaratmir sadece birinci yaradilmish requsterlin 10% ni buna gonderir.
nginx.ingress.kubernetes.io/canary: "true" tells ingress-nginx to treat this ingress differently and mark it as “canary”. What this means internall is the controller is not going to try to configure a new Nginx virtual host for this ingress as it would normally do. Instead it will find the main ingress for this using host and path pair and associate this with the main ingress.
As you can guess nginx.ingress.kubernetes.io/canary-weight: "10" is what tells the ingress-nginx to configure Nginx in a way that it proxies 10% of total requests destined to echo.com to echoserver service under echo-canary namespace, a.k.a to the canary version of our app.






Test Canary Deployment.

Canary script in ruby.

ruby count.rb 

App 1 logs 
kubectl logs -f http-svc-6dcc4d484b-pnfvd   -n echo-production 

App2 logs
kubectl logs -f http-svc-6dcc4d484b-24wdr  -n echo-canary

And change height to 50%
kubectl apply -f http-svc-ing-canary.yaml -n echo-canary
ingress.extensions/http-svc configured
ruby count.rb
{"echo-production"=>515, "echo-canary"=>485}

You can also use cookie for always use sample backend

You can also do Blue-Green Deployment with set second app to 100%  only request come to second app

https://www.elvinefendi.com/2018/11/25/canary-deployment-with-ingress-nginx.html

```

