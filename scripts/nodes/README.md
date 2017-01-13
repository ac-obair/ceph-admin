The servers

The network

The cluster
 
 Administering

 The over all cluster health is dependent on the status of mons and the status of osds which can change independent of each other. osds must be balanced and mons quorate for this to be so. 

 What is quorate?
  at least more than half of the monitors registered in the cluster must be available if this is 3 a quorum is considered quorate with 2 mons. If the cluster is not quorate it's state is degraded and depending on configuration will stop all writes. This is to stop data drift, however we have configured single writes on degraded state, although writes will still happened a single osd will fill very quickly under normal use. Once other osds become reachable it will rebalance. 

 Main status commands 

Health
  ceph -s : show quick over all cluster status
  ceph -h/health : output health only
  ceph -w : follow current cluster activity
 
 Basic admin tasks
   pg_num and pgp_num: Ceph is looking for anywhere from 20 to 32 placement groups per OSD this results in num_of_osds * 20 for the min() and num_of_osds * 32 for the max() that you're allowed to set for your cluster. These values DO NEED TO BE alter if you add or take away osds. Too little or too few will result in cluster health ERR or WARN as the ceph cannot evenly distribute pgs. ** I do not know why this is a manual setting should be automatic but it is. **

Mon
  ceph mon dump:   shows quorum mons and their status
  ceph mon stat:   shows similar to dump in json format
  ceph mon_status: shows the same as dump in json format

Osd
  ceph osd stat:  shows excerpt from ceph -s showing only osd status  
  ceph osd tree:  one of the best commands shows osds up/in down/out as well as weight and placement in the infrastructure. This basically shows the crush map whereby the underlying infrastructure is defined.

  Troubleshooting
  
  radosgw:
     Install no issue, however they don't start, due to some bug that I can't quite pin down. 
     Basically a keyring for rgw is generated when 'rgw create' command is run and placed in 
     /var/lib/ceph/radosgw/ceph.rgw.{hostname}/keyring. 
     The command used by the systemd unit of ceph uses a '--name' parameter 

       --name client.rgw.{hostname} 

     The issue with the daemon failing to start is that systemd unit uses a template and passes a var 
     'client.%i' where the %i contains the wrong value, which means the daemon can't find the keyring file 
     and can't authenticate against the cluster. 

     It will give an error Unable to initialize RADOS stroage in the log files. /var/log/ceph/

     Resolution:
       vi /usr/lib/systemd/system/ceph-radosgw@.service
       sub client.%i for client.{hostname}
       systemctl daemon-reload
       systemctl start {ceph radosgw service}

 Deployment


ceph-deploy new

ceph-deploy install

ceph-deploy mon create-initial

ceph-deploy disk list

Creating osds:
 When you create osds, you can use 
  osd zap: this clears the block devices
  osd prepare: this preps them for ceph use i.e. reads them into the cluster and formats/mounts them for use
  osd activiate: this brings them into the cluster
 
  HOWEVER there's an osd create command, that will run the prepare and activiate stages for you in one. 
 
  clear disks:
   ceph-deploy disk zap mrlceph-strg02:sdb
   ceph-deploy disk zap mrlceph-strg02:sdc
   ceph-deploy disk zap mrlceph-strg02:sdd
   ceph-deploy disk zap mrlceph-strg02:sde
  create and activate osds: 
  ceph-deploy osd create {hostname}:{osd_disk}:{path_to_journal}
  
  Note:
    with the above command path_to_joural can be a blank block device /dev/sdb or you can specify it to be to the first partition of a block device /dev/sdb1 ceph WILL create this for you, you do not have to interact with the disks unless you mess it up.

  ceph-deploy osd create mrlceph-strg02:sde:/dev/sdb1 mrlceph-strg02:sdd:/dev/sdc1

Recreating osds (if you mess it up):
 Things to note:

 I find it best to completely start again, as even if you remove everything that needs to be removed linux will cache certain things I can never pin down. The best procedure is to: 
 
 # removes everything ceph package related
 ceph-deploy purge mrlceph-strg02 

 # removes all created mount points and config files        
 ceph-deploy purgedata mrlceph-strg02

 # ssh to the remote box in question and remove the systemd units
 systemctl list-units --type=service | grep -i ceph
 systemctl disable {name_of_ceph_service} # do this for all
 rm -rf /etc/systemd/system/ceph*
 systemctl daemon-reload
 systemctl reset-failed     # precaution might not be needed after daemon-reload you can check
 systemctl reboot           # this is important to flush any caching
 
 # now reinstall ceph packages after reboot, this allows the prep utilities to be redeployed
 ceph-deploy install mrlceph-strg02

 # Go back over the disks for good measure
 ceph-deploy disk zap mrlceph-strg02:sdb
 ceph-deploy disk zap mrlceph-strg02:sdb
 ceph-deploy disk zap mrlceph-strg02:sdc
 ceph-deploy disk zap mrlceph-strg02:sdd
 ceph-deploy disk zap mrlceph-strg02:sde

 ceph-deploy osd create mrlceph-strg02:sde:/dev/sdb1 mrlceph-strg02:sdd:/dev/sdc1

 # Check they have been loaded into the crush map and are up/in
 ceph osd tree

Errors
 ceph-deploy uses sudo: ensure proxy settings preserved when sudoing by adding 
   Defaults    env_keep += "ftp_proxy http_proxy https_proxy no_proxy"
   to the visudo (etc/sudoers) file

 no section 'ceph': change ceph.repo to ceph-deploy.repo, note this is only required on the ceph-admin box
 
 unable to find any IP address in networks: our public network spans 2 subnets, ceph can accept a comma 
 delimited list of subnets for it's public networks ensure you specify

  public network = ip/cidr,ip/cidr


TODO
ansible
 create user
 template: 
   ssh/confg, 
   /etc/hosts 
 
 from the inventory file, distribute
 change require tty visudo inplace

 
