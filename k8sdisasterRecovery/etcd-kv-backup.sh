#!/usr/bin/env bash
# exit from script if error happen
set -e               

# Define script variables
backupDir=/mnt/backup/bankzone/etcd
date=$(date +%Y/%m/%d)
tarix=$(date +%H%M%S)
days_to_Keep=15
certDir=/root/scripts/etcd_creds
 
# List endpoint ip
endpoints="10.0.0.1,10.0.0.2,10.0.0.3"
Field_Separator=$IFS

IFS=,
for i in $endpoints;
do  
    date 
    echo "------  Starting backup $i database  ------"
    mkdir -p $backupDir/$i/$date
    ETCDCTL_API=3 etcdctl    --cacert $certDir/ca.pem   --key $certDir/member-master01-key.pem --cert  $certDir/member-master01.pem --endpoints https://$i:2379  snapshot save  $backupDir/$i/$date/$i-$tarix.db
   
    if [ $? == '0' ];
    then
       echo "--- Backup finished  for $i database ---"
    else
       echo "Backup  unsuccessfully finished  for $i database, error happened" | mail -s "Etcd Backup Status" -r "backup@gmai.com"  test@gmail.com
    fi

    echo "--- Archiving $i database ---"
    cd  $backupDir/$i/$date && tar -czf $i-$tarix.tar.gz $i-$tarix.db && rm -rf $i-$tarix.db
    
    echo "--- Find and delete $days_to_Keep days ago backups for  $i database ---"
    find $backupDir/$i  -mtime +$days_to_Keep -name "*.tar.gz" -exec rm -rf '{}' ';'
    echo -e "\n" 

done
IFS=$Field_Separator