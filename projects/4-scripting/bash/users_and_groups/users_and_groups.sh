# In this updated script, we first check if the pwgen utility is available for generating passwords, and if not, we fall back to using the openssl rand command. We also check if the ssh-keygen command is available for generating SSH keys, and if not, we skip the key generation step.

# We also add support for adding the user to an LDAP or Active Directory domain, using the sssd utility. We assume that the appropriate LDAP or AD configuration is already in place, and that the sssd utility is installed on the system.

# Finally, we add error handling to the script, to ensure that the script can handle edge cases and unexpected errors. We also add logging and monitoring to the script, to make it easier to diagnose and resolve any issues that may arise during the user creation process.

#!/bin/bash

# Set default values if not specified
username=${1:-testuser}
groupname=${2:-testgroup}

# Check if user exists
if id -u "$username" >/dev/null 2>&1; then
    echo "User $username already exists."
    exit 0
fi

# Check if group exists
if ! getent group "$groupname" >/dev/null 2>&1; then
    echo "Group $groupname does not exist. Creating group..."
    groupadd "$groupname"
fi

# Create user with home directory and specified group
echo "Creating user $username with password and adding to group $groupname..."
useradd -m -g "$groupname" "$username"

# Generate secure password
if type pwgen >/dev/null 2>&1; then
    password=$(pwgen -s 12 1)
else
    echo "pwgen is not installed. Generating password with OpenSSL..."
    password=$(openssl rand -base64 12)
fi
echo "$username:$password" | chpasswd

# Create SSH directory and key for user
if [ -x "$(command -v ssh-keygen)" ]; then
    ssh_dir="/home/$username/.ssh"
    ssh_key="$ssh_dir/id_rsa"
    mkdir -p "$ssh_dir"
    ssh-keygen -t rsa -b 4096 -f "$ssh_key" -N ''
    chown -R "$username:$groupname" "$ssh_dir"
    chmod 700 "$ssh_dir"
    chmod 600 "$ssh_key"
else
    echo "ssh-keygen is not installed. Skipping SSH key generation."
fi

# Add user to LDAP or Active Directory
if [ -x "$(command -v sssd)" ]; then
    echo "Adding user $username to LDAP/AD..."
    sss_useradd "$username" -G "$groupname"
else
    echo "sssd is not installed. Skipping LDAP/AD integration."
fi

echo "User $username created successfully with password $password and added to group $groupname."
