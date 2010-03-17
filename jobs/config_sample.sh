#!/bin/sh
set -e

# ==============================================================================
# User options
# ==============================================================================
# The absolute path to where each site's www data is.
# example: /hsphere/local/home/username
backuptargets=/var/www/vhosts

# Use a rotating backup name.
# backuprotate=0 turns off backup rotation
# backuprotate=1 will create a set of files ending with:
#    -day-1, day-2, day-3, day-4, day-5, day-6
#    -week-1, -week-2, -week-3, -week-4, -week-5
#    -month-01, -month-02, ..., -month-12
#    -year-2010, -year-2011...
backuprotate=1

# The location for the final compressed backup files
backupfiles=/var/www/vhosts/backup/files

# A set of 'find' parameters to specify directories not to backup.
# Make sure your $backupfiles specified above are excluded, if they're in the
# $backuptargets directory!!
# example: "backup chroot"
backupexcludes="backup chroot"

# The location of the main superbackup scripts and job definitions
# example: /hsphere/local/home/username/backups/jobs
backupjobs=/var/www/vhosts/backup/jobs

# The location to store the temporary files created during backups
# example: /hsphere/local/home/username/backups/temp
backuptemp=/var/www/vhosts/backup/temp

# Wether or not to process MySQL databases
# Set to 1 to process, or 0 to skip
processmysql=0

# The username and password for the MySQL server
mysqlusername=root
mysqlpassword=rootpassword
