#!/bin/bash

rules=rules.d/10-local.rules


for node in 3; do 
    echo scp $rules ceph-osd$node:/etc/udev/$rules
    id=0
    for device in sdb1 sdc1 sdd1; do 
        let id=$id+1
        echo ssh ceph-osd$node "sudo chown ceph:ceph /dev/sde$id"
        echo ceph-deploy osd activate ceph-osd$node:$device:/dev/sde$id
 done;
done
