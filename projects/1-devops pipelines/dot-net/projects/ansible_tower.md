**1. Setting Up Ansible Tower:**

Ansible Tower (or AWX, its open-source counterpart) is a web-based solution that makes Ansible easier to use by providing a more visual experience, useful for those who may not have the time or inclination to get familiar with Ansible's CLI (command-line interface). 

To install Ansible Tower, follow these steps:

a. Download the latest Ansible Tower package from the Ansible website.
b. Unpack the package using the command `tar xvzf <ansible-tower-setup-latest>.tar.gz`.
c. Change into the directory that was just created (`cd <ansible-tower-setup-latest>`).
d. Edit the `inventory` file to suit your needs (see the official Ansible Tower Installation Guide for more details).
e. Run the setup script with the command `sudo ./setup.sh`.

Once Ansible Tower is installed, you can access the web interface at `http://<your_ansible_tower_host>:80`.

**2. Developing Advanced Playbooks and Workflows:**

In Ansible Tower, you can create complex workflows to orchestrate your playbooks. Here's how you can do it:

a. After logging in to Ansible Tower, go to "TEMPLATES" from the left menu.
b. Click on "+ ADD", and then "Workflow Template".
c. Fill in the details like `NAME`, `DESCRIPTION`, `ORGANIZATION`, etc., and then click on `SAVE`.
d. Click on the `WORKFLOWS` tab, and you should be able to see your newly created workflow.
e. Click on the workflow name, and then click on `ADD NODE` to start designing your workflow.
f. In the new node, you can select the playbook to be executed, and once selected, click on `SELECT`.
g. Repeat step (e) and (f) to add more nodes to the workflow. You can also specify the execution condition (success, fail, or always) for each node.
h. Once you are done, click on `SAVE`.

**3. Automating Infrastructure Provisioning, Configuration, and Application Deployments:**

With Ansible Tower, you can fully automate your infrastructure provisioning, configuration, and application deployments. 

For instance, you might have the following sequence in your workflow:

a. Node 1: Provision new servers on a cloud provider. This could be an Ansible playbook that uses the necessary cloud modules (like `ec2` for AWS) to create new servers.

b. Node 2 (executed after success of Node 1): Configure servers. This could be an Ansible playbook that sets up the necessary packages, users, and configurations on the servers.

c. Node 3 (executed after success of Node 2): Deploy applications. This could be an Ansible playbook that pulls the latest code from your repository, installs any necessary dependencies, and starts the application.

In addition to the automated workflows, Ansible Tower provides role-based access control, job scheduling, graphical inventory management, and more.

Remember that with Ansible, the limit is your imagination. If you can do it on a Linux/Windows system, you can automate it with Ansible.

