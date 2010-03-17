#!/bin/bash
set -u # Make sure variables are declared
set +e # Continue on errors

backup_mysql()
{
	tempfile=$backuptemp/mysql-$1.sql
	compfile=$backuptemp/mysql-$1.tgz

	StartMessage "DB: $1: Dumping SQL..."

    mysqldump \
	--add-drop-table \
	--add-locks \
	--all --quick \
	--lock-tables \
	--complete_insert \
	--extended_insert \
	--quote-names \
	--host=localhost --user=$mysqlusername --password=$mysqlpassword $1 > $tempfile

	if [[ $? -ne 0 ]]; then
		EndMessage "error"
	else
		EndMessage "ok"
	fi

	StartMessage "DB: $1: Compressing file..."
	if [[ -f $tempfile ]]; then
		tar czf $compfile $tempfile &> /dev/null
		if [[ $? -ne 0 ]]; then
			EndMessage "error"
		else
			rm $tempfile
			EndMessage "ok"
		fi
	else
			EndMessage "skipped"
	fi

	# Move temp file to backup location to stop downloading of partial backups
	StartMessage "DB: $1: Moving backup..."
	if [[ -f $compfile ]]; then
		mv $compfile $backupfiles
		if [[ $? -ne 0 ]]; then
			EndMessage "error"
		else
			EndMessage "ok"
		fi
	else
			EndMessage "skipped"
	fi
}


backup_files()
{
	compfile=$backuptemp/$1-files-$filename.tgz

	# Backup the files
	StartMessage "Files: $1: Compressing files..."
	tar czf $compfile -X $backupjobs/file-excludes.txt $backuptargets/$1 &> /dev/null
	if [[ $? -ne 0 ]]; then
		EndMessage "error"
	else
		EndMessage "ok"
	fi

	# Move temp file to backup location to stop downloading of partial backups
	StartMessage "Files: $1: Moving backup..."
	if [[ -f $compfile ]]; then
		mv $compfile $backupfiles
		if [[ $? -ne 0 ]]; then
			EndMessage "error"
		else
			EndMessage "ok"
		fi
	else
			EndMessage "skipped"
	fi
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
