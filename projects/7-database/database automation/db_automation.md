<p><strong>Task:</strong> As a DevOps engineer, my responsibility was to ensure the consistent, reliable backup of all data covering multiple databases to prevent data loss due to unforeseen issues like hardware failure, system malfunction, or accidental deletions.</p>

<h3>Step 1: Install Percona Xtrabackup</h3>

<p>To install Percona Xtrabackup, you can use the official repositories or download the packages from the website<sup>[1][4]</sup>. For example, on Debian or Ubuntu, you can run the following commands:</p>

<pre>
<code># Add Percona repository
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
sudo percona-release setup ps80

# Install Percona Xtrabackup
sudo apt-get update
sudo apt-get install percona-xtrabackup-80
</code></pre>

<h3>Step 2: Create a full backup</h3>

<p>To create a full backup of your MySQL databases, you can use the xtrabackup command with the --backup and --target-dir options. For example, to backup all databases to the /data/backups/base directory, you can run the following command:</p>

<pre>
<code>xtrabackup --backup --target-dir=/data/backups/base
</code></pre>

<p>This command will copy all the data files and log files from the MySQL data directory to the target directory. It will also create a file called xtrabackup_checkpoints in the target directory, which contains information about the backup, such as the LSN (log sequence number) of the database at the end of the backup.</p>

<h3>Step 3: Create an incremental backup</h3>

<p>To create an incremental backup of your MySQL databases, you can use the xtrabackup command with the --backup, --target-dir, and --incremental-basedir options. For example, to backup only the data that has changed since the last full backup to the /data/backups/inc1 directory, you can run the following command:</p>

<pre>
<code>xtrabackup --backup --target-dir=/data/backups/inc1 --incremental-basedir=/data/backups/base
</code></pre>

<p>This command will copy only the pages that have an LSN higher than the LSN of the last full backup. It will create delta files in the target directory, such as ibdata1.delta or test/table1.ibd.delta. It will also create a file called xtrabackup_checkpoints in the target directory, which contains information about the incremental backup, such as the from_lsn and to_lsn of the database.</p>

<p>You can repeat this step to create multiple incremental backups based on the previous incremental or full backup. For example, to create a second incremental backup based on the first incremental backup to the /data/backups/inc2 directory, you can run the following command:</p>

<pre>
<code>xtrabackup --backup --target-dir=/data/backups/inc2 --incremental-basedir=/data/backups/inc1
</code></pre>

<h3>Step 4: Automate the backup process</h3>

<p>To automate the backup process, you can write shell scripts that run the xtrabackup commands periodically using cron jobs. For example, you can create a script called full_backup.sh that runs a full backup every week on Sunday at 1 AM:</p>

<pre>
<code>#!/bin/bash

# Define variables
BACKUP_DIR=/data/backups
FULL_DIR=$BACKUP_DIR/base

# Create full backup directory if not exists
mkdir -p $FULL_DIR

# Run full backup
xtrabackup --backup --target-dir=$FULL_DIR

# Delete old incremental backups if any
rm -rf $BACKUP_DIR/inc*
</code></pre>

<p>You can also create a script called incremental_backup.sh that runs an incremental backup every day at 1 AM, except on Sunday:</p>

<pre>
<code>#!/bin/bash

# Define variables
BACKUP_DIR=/data/backups
FULL_DIR=$BACKUP_DIR/base
INC_DIR=$BACKUP_DIR/inc$(date +%Y-%m-%d)

# Create incremental backup directory if not exists
mkdir -p $INC_DIR

# Find latest backup directory as base for incremental backup
LATEST_BACKUP=$(find $BACKUP_DIR -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -nr | head -1)
LATEST_BACKUP_DIR=$BACKUP_DIR/$LATEST_BACKUP

# Run incremental backup based on latest backup
xtrabackup --backup --target-dir=$INC_DIR --incremental-basedir=$LATEST_BACKUP_DIR
</code></pre>

<p>You can then add these scripts to your crontab file using the crontab -e command. For example, you can add these lines to your crontab file:</p>

<pre>
<code># Run full backup every Sunday at 1 AM
0 1 * * 0 /path/to/full_backup.sh

# Run incremental backup every day at 1 AM, except Sunday
0 1 * * 1-6 /path/to/incremental_backup.sh
</code></pre>

<p>This way, you can automate the backup process across all existing databases on the system.</p>