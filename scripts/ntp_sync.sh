#!/bin/bash

echo configuring ntp on $(hostname)
echo stopping service && sudo systemctl stop ntpd && sleep 3;
sudo systemctl status ntpd | awk 'FNR==3';
echo syncing time && sudo ntpdate -s utils.arnoldclark.com;
echo syncing clocks && sudo hwclock --systohc;
echo starting service && sudo systemctl start ntpd;
sudo systemctl status ntpd | awk 'FNR==3';
date && sleep 3

