#!/bin/bash

ceph-deploy osd create prdceph-strg01:sde:/dev/sdb1 prdceph-strg01:sdd:/dev/sdc1
ssh prdceph-strg01 "sudo shutdown -r now"
echo
echo
echo prdceph-strg01 should be created
echo
echo


ceph-deploy osd create mrlceph-strg02:sde:/dev/sdb1 mrlceph-strg02:sdd:/dev/sdc1
ssh mrlceph-strg02 "sudo shutdown -r now"
echo
echo
echo mrlceph-strg02 should be created
echo
echo


