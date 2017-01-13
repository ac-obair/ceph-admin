#!/bin/bash

for node in $(cat extra/osd); do
  for disk in $(cat extra/disks); do
    ceph-deploy disk zap $node:$disk
    sleep 1
    echo
    echo
    echo $node $disk is now clean please wait while it reboots
    echo
    echo
 done 
    ssh $node "sudo shutdown -r now"
done

