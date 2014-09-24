#!/bin/bash
username="root"
password=""
hostname="127.0.0.1"
#databases=( "availability97" "fivede61_dotclear" )
EXCLUDED_DB="Database|information_schema|performance_schema|mysql|the_test|demo"
#databases= $(mysql -h 127.0.0.1 -P 3306 --user=root -e "SHOW DATABASES;" | grep -Ev "($EXCLUDED_DB)")
databases=$( echo "show databases;" | mysql -h 127.0.0.1 -P 3306 --user=root | grep -Ev "($EXCLUDED_DB)" 2>&1)

backup=""
strip="--strip-components=1"

index=0

#bash -x -o igncr dump.sh

while [ "$index" -lt ${#databases[@]} ]
do
	database=${databases[$index]}
	basename="$database-`date +%Y%m%d`"
	tmp_path="$basename"
	tmp_file="$tmp_path.tgz"

	mysql_parameters="--user=$username --password=$password --host=$hostname"

	use_dump=$( echo "SELECT ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'the_test' AND TABLE_NAME = 'dc_blog';" | mysql -h 127.0.0.1 -P 3306 --user=root)

	$use_dump

	# mysqlhotcopy -u root -h 127.0.0.1 the_test ./
	# exit
	mkdir -p $tmp_path

	for table in `mysql $mysql_parameters --database=$database -e "SHOW TABLES" -B -N`
	do
		if [ $table != "omit1" -a $table != "omit2" ];
		then
			#mysqldump $mysql_parameters $database $table --single-transaction=true --add-drop-table=true > $tmp_path/$table.sql
			#mysqlhotcopy -u root -h 127.0.0.1 $database ./
		else
			mysqlhotcopy -u root -h 127.0.0.1 $database .
		fi
	done

	#tar -czvf $tmp_file $tmp_path $strip
	#rm -r $tmp_path

	((index++))
done

# SELECT ENGINE
# FROM information_schema.TABLES
# WHERE TABLE_SCHEMA = 'the_test'
# AND TABLE_NAME = 'dc_blog'