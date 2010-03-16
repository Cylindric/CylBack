#!/bin/bash

backup_mysql()
{
	echo Backing up database $1

	# Backup the database
    mysqldump \
	--add-drop-table \
	--add-locks \
	--all --quick \
	--lock-tables \
	--complete_insert \
	--extended_insert \
	--quote-names \
	--host=localhost --password=tBpDCHecfAR7o --user=sysadmin $1 > $backuptemp/mysql-$1.sql

	# Move temp file to backup location to stop downloading of partial backups
	mv $backuptemp/* $backupfiles
}

backup_files()
{

	echo Backing up files from $1 to $filename

	# Backup the files
	tar czf $backuptemp/$1-files-$filename.tar.gz -X $backupjobs/file-excludes.txt $backuptargets/$1 &> /dev/null

	# Move temp file to backup location to stop downloading of partial backups
	mv $backuptemp/* $backupfiles

}

backup_logs()
{

	echo Backing up $1 to $filename

	# Backup the log files
	tar czf $backuptemp/$1-logs-$filename.tar.gz -X $backupjobs/file-excludes.txt ~/logs/$1/*.gz &> /dev/null

	# Move temp file to backup location to stop downloading of partial backups
	mv $backuptemp/* $backupfiles

}


dulog()
{
	case "$1" in
	  "logs")
	  	;;

	  *)
		du -s $backuptargets/$1 >> $backuptemp/du-$filename.txt
		;;
	esac
}

dulog_flush()
{
	mv $backuptemp/du-$filename.txt $backupfiles
}
