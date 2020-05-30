services=$(kubectl get deploy | grep -iE -v -e consul*  -e ms-account -e ms-customer -e ms-scoring -e ms-teller -e redis -e vault*  -e postgres -e gw-branch -e kb-workplace  | awk '{print $1}' | grep  -iE -v Name)
for i in $services; do kubectl scale deployment $i --replicas=0; done
for i in $services; do kubectl scale deployment $i --replicas=1; done