<!DOCTYPE html>
<html>

<head>
  <title>DevOps Engineer Task</title>
</head>

<body>
  <h1>Situation</h1>
  <p>I was hired as a devops engineer for a company that needed to automate the initial configuration of servers for various projects and environments. The company had a large number of servers that required consistent and repeatable configuration across different operating systems and platforms. The company also wanted to reduce the manual effort and human error involved in configuring servers.</p>

  <h1>Task</h1>
  <p>My task was to use Ansible to automate the initial configuration of servers. Ansible is an open-source tool that uses YAML-based playbooks to define the desired state of servers and execute tasks to achieve that state. Ansible also uses an agentless architecture that relies on SSH for communication and does not require any additional software installation on the servers. I had to develop playbooks to set up user accounts, install necessary packages, configure SSH access, and perform basic system configurations on the servers.</p>

  <h1>Action</h1>
  <ol>
    <li>I installed Ansible on my local machine and configured it to use SSH keys for authentication. I also created an inventory file that listed the hostnames or IP addresses of the servers that I wanted to configure, grouped by project and environment. I also created a group_vars directory that contained variables that were common to each group of servers, such as user names, passwords, package names, etc.</li>
    <li>I created a playbook for setting up user accounts on the servers. The playbook consisted of tasks that used the user module to create user accounts with specified names, passwords, groups, home directories, etc. The playbook also used the authorized_key module to add SSH public keys to the user accounts for passwordless login. The playbook also used handlers and notify directives to restart the SSH service whenever a user account was modified.</li>
    <li>I created another playbook for installing necessary packages on the servers. The playbook consisted of tasks that used the package module to install packages with specified names and states (present or absent) on the servers. The playbook also used conditionals and facts to check the operating system and platform of each server and install packages accordingly. The playbook also used loops and with_items directives to iterate over a list of packages and install them in one task.</li>
    <li>I created another playbook for configuring SSH access on the servers. The playbook consisted of tasks that used the lineinfile module to modify the SSH configuration file (/etc/ssh/sshd_config) on the servers. The playbook also used variables and templates to customize the SSH configuration file based on different parameters, such as port number, protocol version, login banner, etc. The playbook also used handlers and notify directives to restart the SSH service whenever the SSH configuration file was modified.</li>
    <li>I created another playbook for performing basic system configurations on the servers. The playbook consisted of tasks that used various modules to perform system tasks, such as setting hostname, timezone, locale, firewall rules, cron jobs, etc. The playbook also used conditionals and facts to check the operating system and platform of each server and perform system configurations accordingly. The playbook also used loops and with_items directives to iterate over a list of system tasks and perform them in one task.</li>
  </ol>

  <h1>Issue/Problem</h1>
  <p>One of the issues or problems that I faced during the task was how to handle errors or failures that occurred during the execution of playbooks. Errors or failures can occur due to various reasons, such as network issues, incorrect syntax, missing dependencies, insufficient permissions, etc. For example, if a package

 installation failed due to a network issue, the playbook would stop running and leave the server in an inconsistent state.</p>

  <h1>Resolution</h1>
  <p>To resolve this issue or problem, I decided to use error handling techniques in Ansible to handle errors or failures gracefully and ensure that the playbooks continued running or exited cleanly. Error handling techniques in Ansible include:</p>
  <ul>
    <li>Using <b>ignore_errors</b> directive to ignore errors or failures for specific tasks and continue running the playbook.</li>
    <li>Using <b>failed_when</b> directive to define custom failure conditions for specific tasks based on their output or return values.</li>
    <li>Using <b>register</b> directive to capture the output or return values of specific tasks and use them in subsequent tasks or conditionals.</li>
    <li>Using <b>block</b>, <b>rescue</b>, and <b>always</b> directives to group tasks into blocks and define error handling actions for each block.</li>
  </ul>
  <p>Using error handling techniques in Ansible has several advantages:</p>
  <ul>
    <li>It prevents playbooks from stopping abruptly due to errors or failures and leaving servers in an inconsistent state.</li>
    <li>It allows playbooks to handle errors or failures in a customized way based on different scenarios and requirements.</li>
    <li>It improves the reliability and robustness of playbooks and ensures that they achieve the desired state of servers.</li>
  </ul>
  <p>To implement error handling techniques in Ansible, I followed these steps:</p>
  <ol>
    <li>I added <b>ignore_errors: yes</b> to tasks that were not critical for the configuration of servers and could be ignored if they failed. For example, I added <b>ignore_errors: yes</b> to the task that set the hostname of the server, as it was not essential for the functionality of the server.</li>
    <li>I added <b>failed_when: condition</b> to tasks that had custom failure conditions based on their output or return values. For example, I added <b>failed_when: result.rc != 0 and 'already installed' not in result.stdout</b> to the task that installed packages on the server, as it should fail only if the return code was not zero and the output did not contain the phrase 'already installed'.</li>
    <li>I added <b>register: variable</b> to tasks that had output or return values that I wanted to use in subsequent tasks or conditionals. For example, I added <b>register: ssh_config_result</b> to the task that modified the SSH configuration file on the server, as I wanted to use its output in a subsequent task that checked if the SSH service needed to be restarted.</li>
    <li>I added <b>block</b>, <b>rescue</b>, and <b>always</b> directives to group tasks into blocks and define error handling actions for each block. For example, I added <b>block</b>, <b>rescue</b>, and <b>always</b> directives to group the tasks that performed system configurations on the server and define error handling actions such as logging the error message, sending an email notification, or reverting the changes.</li>
  </ol>

  <h1>Result</h1>
  <p>As a result of my actions, I was able to use Ansible to automate the initial configuration of servers for various projects and environments.

 I was able to develop playbooks to set up user accounts, install necessary packages, configure SSH access, and perform basic system configurations on the servers. I was also able to use error handling techniques in Ansible to handle errors or failures gracefully and ensure that the playbooks continued running or exited cleanly. I received positive feedback from my supervisor and client for my work on the task.</p>
</body>

</html>

---


Server Configuration: Use Ansible to automate the initial configuration of servers. Develop playbooks to set up user accounts, install necessary packages, configure SSH access, and perform basic system configurations.

Ansible is a powerful automation tool for configuration management and application deployment. It uses declarative language to describe system configurations. Here is a step-by-step guide to using Ansible to automate the initial configuration of servers, including setting up user accounts, installing necessary packages, configuring SSH access, and performing basic system configurations.

**1. Ansible Installation:**

Depending on your OS, the command to install Ansible may differ. On a Debian-based system like Ubuntu, you would use:

```bash
sudo apt-get update
sudo apt-get install ansible
```

On a RedHat-based system like CentOS, you would use:

```bash
sudo yum install ansible
```

**2. Configuring Ansible:**

Create a directory for your Ansible project and navigate into it:

```bash
mkdir ~/ansible-config && cd ~/ansible-config
```

Inside this directory, create an Ansible configuration file:

```bash
touch ansible.cfg
```

Add the following content:

```ini
[defaults]
inventory = ./inventory.ini
```

This specifies that Ansible should look for an inventory file in the same directory.

**3. Setting Up the Inventory File:**

Create a new file named `inventory.ini`:

```bash
touch inventory.ini
```

Add your servers to the inventory file:

```ini
[webservers]
192.0.2.0
192.0.2.1
```

**4. Create a User Account Setup Playbook:**

Create a new file named `user-setup.yml`:

```bash
touch user-setup.yml
```

Define a playbook to create a user account on your servers:

```yaml
---
- name: Set up user accounts
  hosts: webservers
  become: yes

  tasks:
    - name: Create user
      user:
        name: myuser
        shell: /bin/bash
        state: present
```

**5. Install Necessary Packages Playbook:**

Create a new file named `packages-setup.yml`:

```bash
touch packages-setup.yml
```

Define a playbook to install necessary packages:

```yaml
---
- name: Install necessary packages
  hosts: webservers
  become: yes

  tasks:
    - name: Ensure Apache is installed
      yum:
        name: httpd
        state: present
```

Replace `yum` with `apt` if you're using a Debian-based system.

**6. Configure SSH Access:**

Create a new file named `ssh-setup.yml`:

```bash
touch ssh-setup.yml
```

Define a playbook to setup SSH:

```yaml
---
- name: Set up SSH access
  hosts: webservers
  become: yes

  tasks:
    - name: Ensure SSH is installed
      yum:
        name: openssh-server
        state: present

    - name: Start SSH service
      service:
        name: sshd
        state: started
        enabled: yes
```

**7. Run the Playbooks:**

With your playbooks defined, you can now run them using the `ansible-playbook` command:

```bash
ansible-playbook user-setup.yml
ansible-playbook packages-setup.yml
ansible-playbook ssh-setup.yml
```

Please replace the IP addresses and user names with your actual server IP addresses and desired user names. Also, keep in mind that this is a very basic example. In a real-world scenario, you might want to make this more dynamic, manage secret data like passwords securely, and handle different kinds of systems in your inventory.

--------------------



Expert Role: IT Educator specializing in DevOps and Configuration Management

Objective: To provide an in-depth, comprehensive playbook using Ansible to automate the initial server configuration, including setting up user accounts, installing necessary packages, configuring SSH access, and performing basic system configurations.

Response:

Below is a sample Ansible playbook that performs the objectives specified:

```yaml
---
- name: Basic server setup
  hosts: servers
  become: yes
  vars:
    username: yourusername
    password: yourpassword  # This should be encrypted in a real setup
    ssh_key_file: /path/to/your/public/key.pub

  tasks:
    - name: Install necessary packages
      apt: 
        name: "{{ item }}"
        state: present
        update_cache: yes
      loop:
        - vim
        - git
        - htop

    - name: Add user
      user:
        name: "{{ username }}"
        password: "{{ password }}"
        shell: /bin/bash
        state: present

    - name: Setup .ssh directory
      file:
        path: "/home/{{ username }}/.ssh"
        state: directory
        mode: '0700'
        owner: "{{ username }}"
        group: "{{ username }}"

    - name: Allow passwordless sudo for user
      lineinfile:
        path: "/etc/sudoers"
        line: "{{ username }} ALL=(ALL) NOPASSWD: ALL"

    - name: Add public key to the new user's authorized keys
      authorized_key:
        user: "{{ username }}"
        state: present
        key: "{{ lookup('file', ssh_key_file) }}"

    - name: Disable Password Authentication
      lineinfile:
        dest: /etc/ssh/sshd_config
        regexp: '^PasswordAuthentication'
        line: 'PasswordAuthentication no'
        state: present
      notify: Restart SSH

  handlers:
    - name: Restart SSH
      service:
        name: ssh
        state: restarted
...
```
This playbook, when run against your group of servers (specified as `servers` under `hosts`), does the following:

1. Installs necessary packages (vim, git, htop) using the apt package manager. The `update_cache: yes` parameter ensures that the package database is updated before installing the packages.

2. Adds a new user with the username and password provided. The user is set up with /bin/bash as their default shell.

3. Sets up a .ssh directory for the new user, with appropriate ownership and permissions.

4. Gives the new user passwordless sudo access by adding an appropriate line to the /etc/sudoers file.

5. Adds a public key to the new user's authorized keys, allowing SSH access to the new user using the provided public key.

6. Disables password authentication in the SSH server configuration.

7. If the SSH configuration is changed, the playbook notifies a handler to restart the SSH service.

For the username, password, and ssh_key_file, you can either replace them directly in this playbook with real values or provide them during runtime.

Remember to replace `yourusername`, `yourpassword`, and `/path/to/your/public/key.pub` with your actual username, password, and path to the public key file respectively. Note that storing passwords in plaintext, as in this example, is not recommended. In a production scenario, you'd likely want to use something like Ansible Vault to securely manage sensitive data.

