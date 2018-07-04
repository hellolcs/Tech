# OpenStack Installation (CentOS 6)

## Network Configuration 
* selinux off
```
$vi /etc/selinux/config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled	// modify
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```
* configure hosts
```
$vi /etc/hosts
...
//add
# controller
xxx.xxx.xxx.xxx   controller

# compute 1
xxx.xxx.xxx.xxx   compute1

# compute 2
xxx.xxx.xxx.xxx   compute2
...
```

## NTP Configuration

* configure ntp on controller-server
```
$vi /etc/ntp.conf
...
server 220.73.142.71	//modify
...
```

* configure ntp on compute-server
```
$vi /etc/ntp.conf
...
server controller 		//modify
...
```

* register on systemd and start
```
$chkconfig --level 2345 ntpd on
$service ntpd start
```


## DataBase Installation on Controller-server
* select mariadb version and copy mariadb repo
 * [MariaDB Foundation](https://downloads.mariadb.org/mariadb/repositories/#mirror=kaist "mariaDB")

* create mariadb.repo
```
$vi /etc/yum.repos.d/mariadb.repo
# MariaDB 5.5 CentOS repository list - created 2018-06-05 09:23 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/5.5/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
enabled=1
```

* install mariadb
```
$yum install -y MariaDB-server MariaDB-client Mariadb
...
====================================================================================================================================================================================================================================
 Package                                                    Arch                                               Version                                                    Repository                                           Size
====================================================================================================================================================================================================================================
Installing:
 MariaDB-client                                             x86_64                                             5.5.60-1.el6                                               mariadb                                              10 M
 MariaDB-compat                                             x86_64                                             5.5.60-1.el6                                               mariadb                                             2.7 M
     replacing  mysql-libs.x86_64 5.1.73-8.el6_8
 MariaDB-server                                             x86_64                                             5.5.60-1.el6                                               mariadb                                              44 M
Installing for dependencies:
 MariaDB-common                                             x86_64                                             5.5.60-1.el6                                               mariadb                                              23 k
 libaio                                                     x86_64                                             0.3.107-10.el6                                             base                                                 21 k

Transaction Summary
====================================================================================================================================================================================================================================
....

```

* configure my.conf
```
$vi /etc/my.cnf
[mysqld]
...
datadir = /data/mariadb 	//modify

//add
bind-address = 172.16.8.102
default-storage-engine = innodb
innodb_file_per_table
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8'
character-set-server = utf8
...
```

* create mariadb directory
```
$mkdir -p /data/mariadb
```

* register on systemd and start
```
$chkconfig --level 2345 mysql on
$service mysql start
```

* create root-user password
```
...
Enter current password for root (enter for none): 
OK, successfully used password, moving on...
...
Set root password? [Y/n] y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!
...
Remove anonymous users? [Y/n] y
 ... Success!
...
Disallow root login remotely? [Y/n] y
 ... Success!
...
Remove test database and access to it? [Y/n] y
...
Reload privilege tables now? [Y/n] y
 ... Success!
...
Thanks for using MariaDB!
```

## OpenStack Packages Installation
* install rdo repository
```
$yum install -y yum-plugin-priorities
...
Installed:
  yum-plugin-priorities.noarch 0:1.1.30-40.el6                                                                                                                                                                                      

Complete!

$yum install -y http://repos.fedorapeople.org/repos/openstack/openstack-icehouse/rdo-release-icehouse-4.noarch.rpm
```

