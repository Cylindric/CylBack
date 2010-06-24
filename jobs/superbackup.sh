#!/bin/bash
set -u # Make sure variables are declared
set +e # Continue on errors
scriptroot=`dirname "$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"`

# ==============================================================================
# Default User options
# ==============================================================================
backuptargets=/var/www/vhosts
backupfiles=`dirname $scriptroot`/files
backupjobs=$scriptroot
backuptemp=`dirname $scriptroot`/temp
backupexcludes="backup chroot"
backuprotate=1
processmysql=1
mysqlusername=root
mysqlpassword=rootpassword


# ==============================================================================
# Shouldn't be anything to change below here unless you REALLY know
# what you're doing
# ==============================================================================
op_finalstatus=ok


# Include the required files
source $scriptroot/config.sh
source $scriptroot/superbackup_functions.sh
source $scriptroot/superbackup_names.sh
source $scriptroot/superbackup_output.sh


# Create the main target dirs required
mkdir -p $backuptemp
mkdir -p $backupfiles
op_filename=`mktemp`

# Clear out the temp folder
StartMessage "Removing backup Temp files"
rm -rf $backuptemp/*
EndMessage ""


# Backup the files
StartMessage "Looking for directories to backup..."
for i in `find $backuptargets -maxdepth 1 -type d`;
do
        i=`basename $i`
        includedir=1
        for exclude in $backupexcludes
        do
                if [[ $i == "$exclude" ]] ; then
                        includedir=0
                fi
        done

        if [ $includedir != 0 ] ; then
                if [ -d $backuptargets/$i ]; then
                        backup_files $i
                fi
        fi

done


# Backup the databases
if [ $processmysql == 1 ]; then
				StartMessage "Looking for databases to backup..."
				EndMessage ""
        for i in `mysql --user=$mysqlusername --password=$mysqlpassword --execute="show databases" | grep -v Database`;
        do
          backup_mysql $i
        done
fi


EndMessage ""

				
# For non-console execution, dump output only if there was a non-ok status
if [ $op_term -eq 0 ]; then
	if [ "$op_finalstatus" != "ok" ]; then
		cat $op_filename
	fi
fi

rm $op_filename
