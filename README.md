### ceph-deploy

*This repo must be made private asap*

Note this repo is to be used along with https://github.com/ac-obair/ceph-cluster which is used for bringing server to a known good state for a ceph cluster to run.

This repo was made for maintaining changes to the core ceph configurations. This can essentially effect anything from performance to replication and data distribution. It's to be used with caution and not by anyone who doesn't understand object storage. 

Here's a link to my gist on how ceph replication actually works:
https://gist.github.com/Lighiche/51d8eada4968e3430be4e68a160a6387


#### How it works?

This repo will decrypt obfuscated values such as `base64` encoded cephx auth keys, configuration details and tunning values onto the production `ceph-admin` instance. This admin box is where all provisioning and tweaks to the cluster are made. 

As the passwordless sudo user `cephuser` on this host the `ceph-deploy/` directory will be the target. 

Ansible will read in a password from the ACS environment in order to decrypt the vault values and provision the ceph configs

#### Passwd binaries

Refer to this repo for instructions on how a vault password is applied when provisioning with ansible.
https://github.com/ac-obair/ansible-template
