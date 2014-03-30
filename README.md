Magento Maintainer
=================

# Backup Script

Magento Maintennance Script / Reindexer
Author: sales@nodeseo.com
(c) 2014 NodeSEO.com

Script is invoked either manually or via cronjob and accepts the following arguments
       ./maintain.sh cleanup
        
       -> Removes backups older than the specified number of ${DAYS}
       -> Clears the Magento Cache directory
       -> Clears Magento sessions older than 2 days
       -> Rebuilds all Magento Indexes using the BetterIndexer.php script
                   -> will fallback to default indexer if does not exist
       -> Cleans the magento logs
      
      ./maintain.sh backup
      
      -> Checks if todays backup already exists
      -> Compresses the website directory and stores the backup in ${DEST_DIR}/backup-DATE.zip
      -> Dumps all MySQL Databases to ${DEST_DIR}/backup-DATE.sql
      -> Copies the ${SRC_DIR}/media directory to ${DEST_DIR}/media so as to keep backups minimal in size

      ./maintain.sh cleanup backup

        -> Executes both processes above
#
#        

TODO
        
      * Better error checking
      * Email notification on errors
      * Database optimisation
      * Extract credentials to external .key file
      
VERSION : 0.0.1       
LICENSE : See https://github.com/nodeseo/magentomaintainer/blob/master/LICENSE
         Released under Apache v2 License
