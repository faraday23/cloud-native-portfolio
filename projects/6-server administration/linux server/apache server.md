<h2>Situation:</h2>
<p>In a previous role as a DevOps engineer at XYZ Corporation, we had a large number of web applications being served by multiple Apache web servers. The process of deploying these web applications, which included tasks like copying application files, setting up virtual hosts, and restarting the Apache server, was being done manually. This process was not only time-consuming but also prone to human errors.</p>

<h2>Task:</h2>
<p>My primary task was to automate the deployment process of web applications to Apache web servers. This included automating tasks like file copying, virtual host setup, and server restarts.</p>

<h2>Action:</h2>
<ol>
  <li>
    <p>To handle this, I wrote a bash script that would take the necessary inputs such as the application file path, server details, and the necessary configuration details for the virtual host. The script would then perform the following steps:</p>
  </li>
  <ol>
    <li>
      <p>Copy the web application files to the appropriate directory on the server using secure copy (scp).</p>
    </li>
    <li>
      <p>Create a new Apache virtual host configuration file with the provided details.</p>
    </li>
    <li>
      <p>Enable the newly created virtual host using a2ensite.</p>
    </li>
    <li>
      <p>Finally, restart the Apache server to apply the changes using systemctl.</p>
    </li>
  </ol>
</ol>

<h2>Issue/Problem:</h2>
<p>The script worked as expected for most deployments, but we encountered an issue where the Apache server would occasionally fail to start after the script ran. This was primarily due to syntax errors in the virtual host configuration files caused by incorrect or incomplete input parameters provided to the script.</p>

<h2>Resolution:</h2>
<p>To resolve this, I added validation checks within the script to ensure that all necessary input parameters were not only provided but also in the correct format. The script would not proceed until all inputs were validated. I also added a step in the script to test the Apache configuration with "apachectl configtest" before attempting to restart the server. If any errors were detected, the script would abort, and the error details would be logged for review.</p>

<h2>Result:</h2>
<p>As a result, we were able to streamline and automate our web application deployment process, drastically reducing the time spent on deployments and virtually eliminating human errors. This also freed up the team's time to focus on more critical tasks, improving overall productivity. Moreover, the added validation checks ensured the integrity of our Apache configurations, leading to higher uptime and reliability of our web applications.</p>
