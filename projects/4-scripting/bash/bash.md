<h2>Situation:</h2>
<p><strong>Situation:</strong> We needed to automate the process of installing MySQL and setting up initial users and permissions on a mix of Ubuntu/Debian and CentOS/Fedora/RHEL systems. The script would be used in a variety of environments, from development to production, where the access requirements might be different.</p>

<h2>Task:</h2>
<p><strong>Task:</strong> My task was to create a Bash script that would install MySQL, open up the appropriate firewall ports, set up a new database and user, and apply the appropriate permissions. The script needed to be robust enough to handle different operating systems and the different user access requirements.</p>

<h2>Action:</h2>
<p>I wrote a Bash script that started by allowing MySQL on port 3306 through the firewall. Then it prompted the user to enter the database name, username, and password. It also asked if the user needed to access the database from different IPs and, if not, prompted for a specific remote IP. It used this information to create a new user and grant appropriate privileges. The script was designed to check the network connectivity, if MySQL was already installed, and the type of the OS before it performed the installation and configuration. It also handled errors gracefully by trapping any errors that occurred during execution and outputting an error message before exiting.</p>

<h2>Issue/Problem:</h2>
<p>During the initial tests, we found out that the database was not being created if it already existed, and the script was failing. This was problematic as in some scenarios, we wanted to add a new user to an existing database.</p>

<h2>Resolution:</h2>
<p>I updated the MySQL commands to include <code>IF NOT EXISTS</code> when creating a new database and user. This meant that the commands would be ignored if the database or user already existed, preventing the script from failing in these scenarios.</p>

<h2>Result:</h2>
<p>As a result of these changes, the script could be run in a variety of environments and configurations, successfully setting up MySQL, creating a database, and configuring user access based on the provided input. It improved the efficiency of the setup process and reduced manual intervention. The script was robust enough to handle different scenarios, whether setting up a new system or modifying an existing one, making it a valuable tool for our DevOps tasks.</p>

<h3>Possible Questions:</h3>
<ol>
  <li>What are the benefits of automating the installation and setup of MySQL?</li>
  <li>How does the script handle different user access requirements?</li>
  <li>What precautions were taken to handle errors gracefully?</li>
  <li>How can the script be customized for different operating systems?</li>
  <li>What are some considerations for securing the MySQL installation?</li>
</ol>


```sh
#!/bin/bash
set -e

# Allow MySQL on port 3306
sudo ufw allow 3306
sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT

# Prompt for sensitive data
read -p "Enter your database name: " DATABASE_NAME
read -p "Enter your username: " USERNAME
read -sp "Enter your password: " PASSWORD; echo

# Determine if access is needed from different IPs
read -p "Does the user need to access the database from different IPs (Y/N)? " ACCESS_DIFF_IPS

if [[ ${ACCESS_DIFF_IPS} = [yY] ]]; then
    HOST='%'
    echo "The user will be able to access the database from any IP address. Please ensure you have other security measures in place."
else
    read -p "Enter the specific remote IP: " REMOTE_IP
    HOST=$REMOTE_IP
fi

trap "echo 'An error occurred. Exiting...'" EXIT

function check_network() {
  wget -q --spider http://google.com

  if [ $? -ne 0 ]; then
    echo "Network connection is not available. Exiting..."
    exit 1
  fi
}

check_network

if dpkg --get-selections | grep -q "^mysql.*install$" >/dev/null; then
    echo "MySQL is already installed. Do you wish to continue (Y/N)?"
    read confirm
    if [[ ${confirm} != [yY] ]]; then
        echo "Exiting..."
        exit 1
    fi
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Cannot determine OS"
    exit 1
fi

case $ID in
    ubuntu|debian)
        echo "Debian-based distribution detected"
        sudo apt-get update || { echo "Failed to update package lists. Exiting..."; exit 1; }
        sudo apt-get install -y mysql-server
        ;;
    centos|fedora|rhel)
        echo "Red Hat-based distribution detected"
        sudo yum check-update || { echo "Failed to update package lists. Exiting..."; exit 1; }
        sudo yum install -y mysql-server
        ;;
    *)
        echo "Unsupported distribution"
        exit 1
        ;;
esac

# A block of commands that is allowed to fail
set +e
# Here you can place cleanup or rollback operations
set -e

sudo mysql -e "
CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;
CREATE USER IF NOT EXISTS '$USERNAME'@'$HOST' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$USERNAME'@'$HOST';
FLUSH PRIVILEGES;
"
```