# common-role

## Introduction

This work shall be included into an [ansible playbook]() as [ansible role]().
This [role]() is intented as a container for all tools and configuration needed as base on 
a [debian]() system.

Topic covered:
* basic tools
* users
* basic firewall policies
* ssh server enforcement

# Common stuff

## Basic tools
This role install the following packages:
```
 rsync
 tmux
 vim
 net-tools
 iptables-persistent
 fail2ban
 sudo
```

## Basic firewall policies
Firewall i managed direclty using the [ansible plugin](), by thefault 
this section will set the following rules:

```
```


## SSH server enforcement 

This role will create the group `ssh`.

This role will create the file `/etc/ssh/sshd_config.d/custom_config.conf` whit this lines:

```
AuthorizedKeysFile	.ssh/authorized_keys # specifies the path for auth keys

PasswordAuthentication no # disable pass authentication
PermitEmptyPasswords no # disable empty passwords authentication

PermitRootLogin no # disable root login via ssh

AllowGroups ssh # only users belonging to the ssh group can login
```

The last measuer taken to enforce ssh server secutiry is the installation of fail2ban with and the activation
of the sshd jail.

The fail2ban configuration are left as default.

## Users
### Special users
#### Admin user
Ansible as orchestrator need an admin user, we assume it is the user you created when you installed the system, and the one you are using to run ansible, it will be added to the ssh group.

This user public key can be controlled using this parameter:
```
ansible_ssh_public_key_file: "{{ lookup('file', '{{ playbook_dir }}/.ssh/admin_rsa.pub') }}"
```

#### `snapshot` user 
This role create system user `snapshot`; this user is part of the ssh group, and a custom sudo
rule is installed, this user can run rsync server as root.

```
snapshot_ssh_public_key_file: "{{ lookup('file', '{{ playbook_dir }}/.ssh/admin_rsa.pub') }}"
```


This can be used to run system backups using [rsnapshot](https://rsnapshot.org/).

### Other users

It is possible to add users to the system adding users to the `other_users` variable; 
all for all username in this list it will be created a user belongin to users and ssh groups.


