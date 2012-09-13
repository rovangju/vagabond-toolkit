#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

MYSQL_USER='debian-sys-maint'
MYSQL_PASS='tm2NhmnNwU5vNM6a'

BACKUP_TARGET='ssh://u@h/dir'

BACKUP_LV='/dev/vg01/MySQL'

mysql -u $MYSQL_USER -p$MYSQL_PASS -e "flush tables with read lock; flush logs;"

lvm lvcreate --size 50M -n backupMySQL -s $BACKUP_LV

if [ ! -d /mnt/backup-mysql ]; then
	mkdir -p /mnt/backup-mysql
fi

mysql -u $MYSQL_USER -p$MYSQL_PASS -e "unlock tables;"

mount -t ext4 -o ro,noatime,nodiratime /dev/vg01/backupMySQL /mnt/backup-mysql

duplicity \
--no-encryption \
--full-if-older-than 1W \
--ssh-options="-oIdentityFile=/root/.ssh/id_backup" \
--include /mnt/backup-mysql \
--exclude '**' \
/ \
$BACKUP_TARGET

# prune old
duplicity \
remove-older-than 6M \
--force \
--ssh-options="-oIdentityFile=/root/.ssh/id_backup" \
$BACKUP_TARGET

umount /dev/vg01/backupMySQL
lvm lvremove -f /dev/vg01/backupMySQL
