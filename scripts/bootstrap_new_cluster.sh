#!/bin/bash

ceph-deploy new $(cat extra/mon)
ceph-deploy install $(cat extra/cluster)

echo
echo
echo Don\'t forget to ammend the ceph.conf file with custom changes before continuing
echo
echo
