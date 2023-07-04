<!DOCTYPE html>
<html>

<head>
  <title>DevOps Engineer Task</title>
</head>

<body>
  <h1>Situation</h1>
  <p>I was hired as a devops engineer for a company that needed to automate the initial configuration of servers for various projects and environments. The company had a large number of servers that required consistent and repeatable configuration across different operating systems and platforms. The company also wanted to reduce the manual effort and human error involved in configuring servers.</p>

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

