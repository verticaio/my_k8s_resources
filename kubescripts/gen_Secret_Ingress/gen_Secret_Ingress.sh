#!/bin/bash
### Set parametrs
cert_pfx_path=$1
pfx_pass=$2
domain_name=$3
kube_ns_name=$4
back_serv_name=$5
back_serv_port=$6
### Check argument count
if [ "$#" -ne 6 ]; then
    echo "Illegal number of parameters, you must use as below"
    echo "Usage: ./gen_Secret_Ingress.sh  cert_pfx_path  pfx_pass domain_name kube_namespace_name back_service_name back_service_port"
    echo "Example:  ./gen_Secret_Ingress.sh  ./test.kblab.local.pfx 123 test.kblab.local atlas-front-test kb-workspace 8080"
    exit 0
fi
### Create requirements directories
mkdir ./certs
mkdir ./manifests
### Extracts private and public keys from pfx 
extract_cert() {
    openssl pkcs12 -in $cert_pfx_path -nocerts -out ./certs/certificate.key -nodes -password pass:$pfx_pass
    openssl pkcs12 -in $cert_pfx_path -nokeys -out ./certs/certificate.pem -password pass:$pfx_pass
}
### Generate Kubernetes Secret Yaml 
make_secret_yaml() {
    key_cert=$(cat  ./certs/certificate.key | base64 | tr -d '\n')
    pub_cert=$(cat  ./certs/certificate.pem | base64 | tr -d '\n')
echo "apiVersion: v1
data:
  tls.crt: $pub_cert
  tls.key: $key_cert
kind: Secret
metadata:
  name: $domain_name
  namespace: $kube_ns_name
type: Opaque " > ./manifests/$domain_name-secret.yaml
}

make_ingress_yaml() {
echo "apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/secure-verify-ca-secret: $domain_name
    nginx.ingress.kubernetes.io/rewrite-target: /
  name: $domain_name
  namespace: $kube_ns_name
spec:
  rules:
  - host: $domain_name
    http:
      paths:
      - backend:
          serviceName: $back_serv_name
          servicePort: $back_serv_port
        path: /
  tls:
  - hosts:
    - $domain_name
  - secretName: $domain_name " > ./manifests/$domain_name-ingress.yaml
}

main () {
  extract_cert
  make_secret_yaml
  make_ingress_yaml
  echo "Manifest files is as below"
  cat ./manifests/$domain_name-secret.yaml
  cat ./manifests/$domain_name-ingress.yaml
}

main







