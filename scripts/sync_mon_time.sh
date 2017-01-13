#!/bin/bash

for node in $(cat extra/mon); do
 echo syncing $node
 ssh $node bash -s < "scripts/ntp_sync.sh"
done

