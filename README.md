### ceph-deploy

*This repo must be made private asap*

This repo was made for maintaining changes to the core ceph configurations. This can essentially effect anything from performance to replication and data distribution. It's to be used with caution and not by anyone who doesn't understand object storage. 

Here's a link to my gist on how ceph replication actually works:
*to be added*

#### How it works?

This repo will decrypt obfuscated values such as `base64` encoded cephx auth keys, configuration details and tunning values onto the production `ceph-admin` instance. This admin box is where all provisioning and tweaks to the cluster are made. 

As the passwordless sudo user `cephuser` on this host the `ceph-deploy/` directory will be the target. 

Ansible will read in a password from the ACS environment in order to decrypt the vault values and provision the ceph configs

### Passwd binary

Basic example:

```
#!/usr/bin/env python
import os

print os.environ['VALUT_PASSWORD']
```
As a result ansible would read in this password from `stdout`

```
VAULT_PASSWORD=$( echo -n "super_secret" | base64)
./.vault_pass.py
c3VwZXJfc2VjcmV0
```
Passwords can also be **stored encrypted** centrally and/or called via secure requests and injected when being used and never in plain text. i.e. not laying around on a gocd config file somewhere or in a users environment.
