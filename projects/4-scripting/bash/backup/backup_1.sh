# To use this script, you would need to replace /path/to/directory with the directory you want to backup and /path/to/backup/directory with the directory where you want to save the backup.

# The script creates a timestamped file name for the backup using the date command. The tar command is then used to create the backup and compress it using the gz compression format. Finally, the script prints a message indicating that the backup is complete.

#!/bin/bash

# Backup script for /path/to/directory
# Specify the source and destination directories

src=/path/to/directory
dest=/path/to/backup/directory

# Create a timestamped file name for the backup
filename=$(date +%Y-%m-%d_%H-%M-%S)-backup.tar.gz

# Create the backup and compress it
tar -czf $dest/$filename $src

# Print a message indicating the backup is complete
echo "Backup of $src completed and saved as $filename in $dest."
