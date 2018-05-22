#!/bin/bash

#I use this to create a little bash script that will backup the database at regular intervals, and I’ll even chuck in deleting backups older than 15 days and move the dump_file in S3_bucket.

#create a few variables to contain the Database_credentials.

# Database credentials

USER="actv8"
PASSWORD="actv8actv8"
HOST="staging.c0aohvgjdiin.us-east-1.rds.amazonaws.com"
DB_NAME="staging"
MyDB_Name="_mysqldump_"
#Backup_Directory_Locations

BACKUPROOT="/backup/mysql_dump"
TSTAMP=$(date +"%d-%b-%Y-%H-%M-%S")
TSTAMP=$(date "+%Y%m%d_%H%M")
echo $DB_NAME$MyDB_Name$TSTAMP
#exit 1
S3BUCKET="s3://actv8-mysql-dump/staging/"

#logging
#LOG_ROOT="/backup/mysql_dump/logs/dump.log"

#Dump of Mysql Database into S3\
#echo "$(tput setaf 2)creating backup of database start at $TSTAMP" >> "$LOG_ROOT"

#mysqldump  -h <HOST>  -u <USER>  --database <DB_NAME>  -p"password" > $BACKUPROOT/$DB_NAME-$TSTAMP.sql

#or
mysqldump -h $HOST -u$USER --databases $DB_NAME -p$PASSWORD  | gzip -c > $BACKUPROOT/$DB_NAME$MyDB_Name$TSTAMP.sql.gz

#exit 1
#| gzip -c > $BACKUP_PATH/$date-$db.gz

#echo "$(tput setaf 3)Finished backup of database and sending it in S3 Bucket at $TSTAMP" >> "$LOG_ROOT"

#Delete files older than 15 days

find  $BACKUPROOT/*   -mtime +15   -exec rm  {}  \;

#s3cmd   put   --recursive   $BACKUPROOT   $S3BUCKET

s3cmd put -r /backup/mysql_dump/staging_mysqldump*.sql.gz s3://actv8-mysql-dump/staging/ && sudo rm -r -f /backup/mysql_dump/*


#echo "$(tput setaf 2)Moved the backup file from local to S3 bucket at $TSTAMP" >> "$LOG_ROOT"

#echo "$(tput setaf 3)Coll!! Script have been executed successfully at $TSTAMP" >> "$LOG_ROOT"


