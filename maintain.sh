#!/bin/bash

# Backup Script
#
# Magento Maintennance Script / Reindexer
# Author: sales@nodeseo.com
# (c) 2014 NodeSEO.com
#
#
# Script is invoked either manually or via cronjob and accepts the following arguments
#        ./maintain.sh cleanup
#        
#        -> Removes backups older than the specified number of ${DAYS}
#        -> Clears the Magento Cache directory
#        -> Clears Magento sessions older than 2 days
#        -> Rebuilds all Magento Indexes using the BetterIndexer.php script
#                    -> will fallback to default indexer if does not exist
#        -> Cleans the magento logs
#
#        
#        ./maintain.sh backup
#        
#        -> Checks if todays backup already exists
#        -> Compresses the website directory and stores the backup in ${DEST_DIR}/backup-DATE.zip
#        -> Dumps all MySQL Databases to ${DEST_DIR}/backup-DATE.sql
#        -> Copies the ${SRC_DIR}/media directory to ${DEST_DIR}/media so as to keep backups minimal in size
#
#        ./maintain.sh cleanup backup
# 
#        -> Executes both processes above
#
#        
# TODO
#        
#        * Better error checking
#        * Email notification on errors
#        * Database optimisation
#        * Extract credentials to external .key file
#        
# VERSION : 0.0.1       
# LICENSE : See https://github.com/nodeseo/magentomaintainer/blob/master/LICENSE
#           Released under Apache v2 License
#

# Get current date
TIMESTAMP=`date +%Y%m%d`

# here I am setting up the backup directory as a variable
DEST_DIR="/backup"
 
# here I am setting up the directory in which I want to backup, again another variable
SRC_DIR="/var/www"
BACKUP=${DEST_DIR}/backup-${TIMESTAMP}.zip

#number of days to keep backups
DAYS=14

#SQL Credentials
USER=<your user>
PASS=<your pass>

#
# if there is no backup for today already, create it.
#
 

# The SQL and Directories have been backed up, lets do some house cleaning
# Delete backups older than 7 days
if [[ $@ == **cleanup** ]]
then
   echo "Removing old backups..."
   find /backup -name 'backup-*' -mtime +${DAYS} -delete
   
   #
   # Clear cache / session buildup
   #
   echo "Clearing the caches..."
     sudo chmod 777 -R ${SRC_DIR}/var/cache
     sudo rm -rf ${SRC_DIR}/var/cache/

     # Clear old session data
   echo "Clearing old sessions..."
     sudo find ${SRC_DIR}/var/session -type f -mtime +2 -exec rm {} \;
     ls -1 ${SRC_DIR}/var/session | wc -l
   echo "sessions remain."
     # Rebuild the indexes in the background
     echo "Rebuilding indexes..."
     sudo php -d memory_limit=2048M ${SRC_DIR}/shell/indexer.php reindexall

     # Clean the logs
   echo "Cleaning the logs..."
     sudo php -d memory_limit=2048M ${SRC_DIR}/shell/log.php clean
     sudo php ${SRC_DIR}/shell/log.php status
else
    echo "Cleanup option not selected..."
fi

# Rather than having multiple copies of the media we exclude from the backup above, but we should keep an upto date copy
if [[ $@ == **backup** ]]
then

   if [ -f ${BACKUP} ];
   then
       echo "Backup for today already exists...skipping"
   else
       echo "Compressing site..."
       sudo zip -r -q ${BACKUP} ${SRC_DIR} -x ${SRC_DIR}/var/\* ${SRC_DIR}/media/\* 
        echo "Backing up media directory..."
        sudo cp ${SRC_DIR}/media -R ${DEST_DIR}/media -f
   fi
   echo "Creating SQL dump..."
       mysqldump -u ${USER} -p${PASS} --all-databases > ${DEST_DIR}/backup-${TIMESTAMP}.sql
  
else
    echo "Backup option not selected..."
fi
