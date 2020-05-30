#!/bin/bash

### Please change appropriate variables and role option for your requirements
### This script create certificates, content and bridge content to these certs, create role , rolebinding and test
### Provided by B.Mammadov
unset http_proxy
unset https_proxy

CLUSTERNAME=preprod.kblab.local
CLUSTER_API=https://kube_ip:6443
NAMESPACE=default
USERNAME=developers
GROUPNAME=kbdevgroup
ROLENAME=developers-reader
CA_LOCATION=/etc/kubernetes/ssl
CSR_FILE=$USERNAME.csr
KEY_FILE=$USERNAME.key
CERTIFICATE_NAME=$USERNAME.crt

sudo openssl genrsa -out ${USERNAME}.key 2048
sudo openssl req -new -key $KEY_FILE -out $CSR_FILE -subj "/CN=$USERNAME/O=$GROUPNAME"
sudo openssl x509 -req -in $CSR_FILE  -CA $CA_LOCATION/ca.crt -CAkey $CA_LOCATION/ca.key -CAcreateserial -out $CERTIFICATE_NAME -days 500

kubectl config set-credentials $USERNAME --client-certificate=$(pwd)/$CERTIFICATE_NAME  --client-key=$(pwd)/$KEY_FILE
kubectl config set-context ${USERNAME}-context --cluster=$CLUSTERNAME --namespace=$NAMESPACE --user=$USERNAME


cat <<EOF | kubectl apply -f -
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: $NAMESPACE
  name: $ROLENAME
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods", "pods/log", "services", "endpoints"]
  verbs: ["get", "watch", "list"]
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods/exec", "pods/proxy", "pods/attach", "pods/portforward"]
  verbs: ["create"]
EOF


cat <<EOF | kubectl apply -f -
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: developers-read-access
  namespace: $NAMESPACE
subjects:
- kind: User
  name: $USERNAME # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: $ROLENAME # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
EOF

kubectl --context=${USERNAME}-context get pods --namespace=$NAMESPACE
if [ $? == 0 ]; then
    echo " Script Succesfuly finished ...."
else
    echo " Error happen "
fi