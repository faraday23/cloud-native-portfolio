<!DOCTYPE html>
<html>
<head>
    <title>Bash Script for Managing Apache Virtual Hosts</title>
</head>
<body>
    <h1>Bash Script for Managing Apache Virtual Hosts</h1>

<p>My primary task was to automate the deployment process of web applications to Apache web servers. This included automating tasks like file copying, virtual host setup, and server restarts.</p>

<br>
    
    
    <ol>
        <li>
            <p>
                I wrote a bash script by starting with a shebang line that specified the interpreter to use. For example, <code>#!/bin/bash</code> told the system to use bash as the interpreter for the script.
            </p>
        </li>
        <li>
            <p>
                I took the necessary inputs from the user using the read command, which read a line from the standard input and assigned it to a variable. For example, <code>read -p "Enter the application file path: " app_path</code> prompted the user to enter the application file path and stored it in the variable app_path.
            </p>
        </li>
        <li>
            <p>
                I copied the web application files to the server using the scp command, which securely transferred files between hosts using SSH. For example, <code>scp -r $app_path user@server:/var/www/html</code> copied the files from the local app_path to the remote /var/www/html directory on the server, using the user account and SSH key for authentication.
            </p>
        </li>
        <li>
            <p>
                I created a new Apache virtual host configuration file using a here document, which allowed me to write multiple lines of text to a file or a command. For example, <code>cat &lt;&lt;EOF &gt; /etc/apache2/sites-available/$app_name.conf</code> wrote everything between EOF and EOF to the file /etc/apache2/sites-available/$app_name.conf, where $app_name was a variable that held the name of the web application.
            </p>
        </li>
        <li>
            <p>
                I wrote the virtual host configuration details using variables and placeholders to fill in the values provided by the user. For example, <code>&lt;VirtualHost *:80&gt;</code> started a virtual host block that listened on port 80, and <code>ServerName $server_name</code> set the server name to the value of the variable server_name. I also used other directives such as DocumentRoot, ServerAlias, ErrorLog, etc. to configure the virtual host as needed.
            </p>
        </li>
        <li>
            <p>
                I ended the here document and the virtual host block using EOF and &lt;/VirtualHost&gt; respectively. For example, <code>&lt;/VirtualHost&gt;</code> closed the virtual host block, and <code>EOF</code> ended the here document and wrote it to the file.
            </p>
        </li>
        <li>
            <p>
                I enabled the newly created virtual host using the a2ensite command, which created a symbolic link from /etc/apache2/sites-available to /etc/apache2/sites-enabled for the given configuration file. For example, <code>a2ensite $app_name.conf</code> enabled the virtual host for the web application with the name $app_name.
            </p>
        </li>
        <li>
            <p>
                Finally, I restarted the Apache server using the systemctl command, which controlled systemd services. For example, <code>systemctl restart apache2</code> restarted the apache2 service and applied the changes made by enabling the virtual host.
            </p>
        </li>
    </ol>
</body>
</html>