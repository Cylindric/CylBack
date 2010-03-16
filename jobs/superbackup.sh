#!/bin/bash
set -e

# ==============================================================================
# User options
# ==============================================================================
# The absolute path to where each site's www data is.
# example: /hsphere/local/home/username
backuptargets=/var/www/vhosts

# Use a rotating backup name
backuprotate=1

# The location for the final compressed backup files
backupfiles=/var/www/vhosts/backup/files

# A set of 'find' parameters to specify directories not to backup.
# Make sure your $backupfiles specified above are excluded, if they're in the
# $backuptargets directory!!
# example: backup chroot
backupexcludes="backup chroot"

# The location of the main superbackup scripts and job definitions
# example: /hsphere/local/home/username/backups/jobs
backupjobs=/var/www/vhosts/backup/jobs

# The location to store the temporary files created during backups
# example: /hsphere/local/home/username/backups/temp
backuptemp=/var/www/vhosts/backup/temp

# Wether or not to process MySQL databases
# Set to true to process, or false to skip
processmysql=0

# The username and password for the MySQL server
mysqlusername=root
mysqlpassword=rootpassword


# ==============================================================================
# Shouldn't be anything to change below here unless you REALLY know
# what you're doing
# ==============================================================================


# Include the required files
source $backupjobs/config.sh
source $backupjobs/superbackup_functions.sh
source $backupjobs/superbackup_names.sh

# Clear out the temp folder
rm -rf $backuptemp/*

# Backup the files
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
if [ $processmysql == true ]; then
        for i in `echo "show databases" | mysql -u $mysqlusername -p$mysqlpassword |grep -v Database`;
        do
          backup_mysql $i
        done
fi