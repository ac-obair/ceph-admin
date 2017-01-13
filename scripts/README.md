For use **after** servers have been provisioned by ansible

These *helper* scripts use the `ceph-deploy` package cmdline utility and should be run one directory above where they are housed in order to take advantage of the command.

`scripts/{scripts}` are not executable by default because some of them are highly dangerous to a cluster
  
### Inteded usage template:

```
  cd scripts/
  cp {scripts} ../{script}
  chmod +x ../{script}
  ../{script}
  rm ../{script}
```

This way the file is never executable until it has been moved, as explained below.

### Order in which to run: 

#### Destroy an existing cluster

ceph packages must be installed inorder to use ceph-deploy utilities to clear disks
`cp remove_osd_disks.sh ../r.sh `
remove all ceph pacakges and associated files
`cp destroy_cluster.sh ../d.sh`

#### Create a new cluster

create a new cluster by installing ceph on all nodes and generating an initial config
`cp bootstrap_new_cluster.sh ../b.sh`
create the new osds
`cp create_osd_disks.sh ../c.sh`

