#!/bin/bash


# This should nuke everything. Copy it to the ceph-deploy dir and +x the scirpt.

for node in $(cat extra/cluster); do  
        ceph-deploy purge $node
        ceph-deploy purgedata $node
        ssh $node "sudo rm -rf /etc/systemd/system/ceph*; sudo rm -rf /var/log/ceph; sudo shutdown -r now"
        echo
        echo
        echo $node is now clean
        echo 
        echo
done

ceph-deploy forgetkeys
cp ceph.conf ceph.conf.back
