#!/bin/sh

###
###
### Author: Francisco Suarez
### MySQL DB Table Dumper
### Description: 
###


MYSQL_USER=""
MYSQL_PASS=""
EXCLUDED_DB="Database|information_schema|performance_schema|mysql"
#TIMESTAMP=$(date +"%F")
#BACKUP_DIR="/backup/$TIMESTAMP"
#MYSQL=/usr/bin/mysql
#MYSQLDUMP=/usr/bin/mysqldump

rm -rf dumps/*.sql

databases=`mysql -h 127.0.0.1 -P 3306 --user=root -e "SHOW DATABASES;" | grep -Ev "($EXCLUDED_DB)"`

for db in $databases
do
	#mysqldump -h 127.0.0.1 -uroot $db > "dumps/$db.sql"
	use $db
	dbtables="show tables"
	for tbl in $dbtables
	do
		echo 'inner'
		#mysqldump -h 127.0.0.1 -uroot $db > "dumps/$db.sql"
	done
done