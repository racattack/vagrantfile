#!/bin/bash

#create the extra groups for db12c role separation
echo "Checking groups for grid and oracle user"

grep ^asmdba:    /etc/group 2>&1 > /dev/null || groupadd -g 54318 asmdba
grep ^asmoper:   /etc/group 2>&1 > /dev/null || groupadd -g 54319 asmoper
grep ^asmadmin:  /etc/group 2>&1 > /dev/null || groupadd -g 54320 asmadmin
grep ^oinstall:  /etc/group 2>&1 > /dev/null || groupadd -g 54321 oinstall
grep ^dba:       /etc/group 2>&1 > /dev/null || groupadd -g 54322 dba
grep ^backupdba: /etc/group 2>&1 > /dev/null || groupadd -g 54323 backupdba
grep ^oper:      /etc/group 2>&1 > /dev/null || groupadd -g 54324 oper
grep ^dgdba:     /etc/group 2>&1 > /dev/null || groupadd -g 54325 dgdba
grep ^kmdba:     /etc/group 2>&1 > /dev/null || groupadd -g 54326 kmdba

#create or modify as required user grid and oracle
echo "verifying grid user"
id grid   2>&1  > /dev/null  && usermod -a -g oinstall -G asmdba,asmadmin,asmoper,dba grid                 || useradd -u 54320 -g oinstall -G asmdba,asmadmin,asmoper,dba grid
echo "verifying oracle user"
id oracle 2>&1 > /dev/null  && usermod -a -g oinstall -G dba,asmdba,backupdba,oper,dgdba,kmdba oracle || useradd -u 54321 -g oinstall -G dba,asmdba,backupdba,oper,dgdba,kmdba oracle

#set initial password
echo oracle | passwd --stdin oracle
echo grid   | passwd --stdin grid

