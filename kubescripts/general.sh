network_list=$(docker network ls | awk '{print $2}' | grep -v  ID)
for i in $network_list
do 
	docker inspect $i | grep -iE  subnet
done


### Delete all rolebind
for i in $(kubectl get RoleBinding | awk '{ print $1}' | grep -iE -v NAME); do kubectl delete RoleBinding $i; done

### Delete all role
for i in $(kubectl get Role | awk '{ print $1}' | grep -iE -v NAME); do kubectl delete RoleBinding $i; done

### List  kube user 
kubectl config view 

### Delete 
kubectl config unset users.dev
Property "users.dev" unset.
kubectl config unset users.develop
Property "users.develop" unset.



#!/bin/bash
> $(docker inspect --format='{{.LogPath}}' crmapi_crm-tomcat_1)
> $(docker inspect --format='{{.LogPath}}' birpaycore_birpaycore_1)
> $(docker inspect --format='{{.LogPath}}' bpmapi_tomcat_1)

for i in $(docker images | grep -iE '<none>' | awk '{ print $3 }'); do docker rmi  $i; done



### Delete docker container log
./script.sh container_name
#!/bin/bash -e
if [[ -z $1 ]]; then
    echo "No container specified"
    exit 1
fi

if [[ "$(docker ps -aq -f name=^/${1}$ 2> /dev/null)" == "" ]]; then
    echo "Container \"$1\" does not exist, exiting."
    exit 1
fi

log=$(docker inspect -f '{{.LogPath}}' $1 2> /dev/null)
truncate -s 0 $log