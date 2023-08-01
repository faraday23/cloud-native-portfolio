Expert Role: IT Educator specializing in DevOps and Configuration Management

Objective: To provide an in-depth, comprehensive teaching of writing, structuring, and executing an Ansible playbook.

Response:

1. **Writing Your First Playbook:** An Ansible playbook is essentially a script composed of one or multiple plays, each of which define the work to be done for a configuration on a managed server (also called the target host). 

   Here is a simple example playbook that installs nginx on a target host:

   ```yaml
   ---
   - name: Install Nginx
     hosts: webservers
     become: yes

     tasks:
     - name: Install epel-release repo
       yum: 
         name: epel-release 
         state: present

     - name: Install Nginb
       yum: 
         name: nginx 
         state: present
   ```

   Let's break this down:

   - `name`: Gives the play a name, which makes the play easier to understand and troubleshoot.
   
   - `hosts`: Specifies on which hosts the playbook will run. This can be a group from your inventory file, or individual hosts. In this case, we are targeting a group called "webservers".
   
   - `become: yes`: Instructs Ansible to use become privilege escalation (sudo by default) to execute tasks.

   - `tasks`: Lists all of the tasks that will be executed in this play.

   - Each task also has a `name` to make output clearer and each task uses a module with some arguments. In this case, the `yum` module is used to manage packages on the target hosts. 

2. **Understanding Ansible Playbook Structure:** The basic structure of an Ansible playbook includes the following key components:

   - **Play:** Play is an ordered set of tasks which should be run against hosts selected from your inventory. The hosts line is a list of one or more groups or host patterns, separated by colons, as described in the Working With Patterns document.

   - **Tasks:** Tasks are the list of actions you want to execute. Each task is a call to an Ansible module, which does a specific job. In our previous example, we used the `yum` module to manage packages on the target hosts.

   - **Handlers:** Handlers are just like regular tasks in an Ansible playbook, but they are only run if the Task contains a notify directive and also indicates that it changed something.

   - **Variables:** Variables in playbooks are very similar to variables in any programming language. They are used to manage differences between systems.

   - **Facts:** Facts are global variables containing information about the system, like network interfaces or operating system.

3. **Writing a Basic Ansible Playbook:** A simple playbook, as shown above, would involve tasks which include invoking Ansible modules with relevant parameters. Ansible modules are reusable, standalone scripts that can be used by the Ansible API or by the ansible or ansible-playbook programs. They return information to ansible by printing a JSON string to stdout before exiting.

4. **Running Your First Playbook:** To run a playbook, you simply use the ansible-playbook command followed by the path to your playbook:

   ```bash
   ansible-playbook /path/to/your/playbook.yml
   ```

   You should see output that looks something like this:

   ```bash
   PLAY [Install Nginx]

   TASK [Install epel-release repo]
   changed: [your_host]

   TASK [Install Nginx]
   changed: [your_host]

   PLAY RECAP
   your_host                  : ok=2    changed=2    unreachable=0    failed=0

    skipped=0    rescued=0    ignored=0   
   ```

Possible Questions:

1. How can I specify which user Ansible should use to execute tasks on the target hosts?
2. How can I run a playbook against a single, specific host?
3. How can I include a variable in my playbook?
4. What's the best way to structure a playbook when managing multiple roles (e.g., webserver, database server)?
5. How can I handle task failures or errors in my playbook?