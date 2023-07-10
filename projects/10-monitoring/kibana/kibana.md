<h2>Task</h2>
<p><strong>Task:</strong> My task was to design and implement a Kibana Visualizations Daashboard to represent data graphically:</p>


<h2>Step 1: Logstash processing and Elasticsearch Indexing</h2>

<p>With the provided Logstash configuration, data should now be processed into Elasticsearch indices that looks similar to this: "type-yyyy.mm.dd". Each type (hospital, contact, social) has its respective index.</p>

<h2>Step 2: Setting an Index Pattern in Kibana</h2>

<p>In Kibana, set an index pattern that matches the indices we created in Logstash.</p>

<ol>
  <li>Navigate to Kibana's web interface (<a href="http://localhost:5601">http://localhost:5601</a> by default) and click on "Management" in the left-hand panel.</li>
  <li>Navigate to "Index Patterns" under Kibana.</li>
  <li>Click on "Create Index Pattern" and input the wanted pattern. For example, to view all the indices, you can use "*" as your index pattern.</li>
</ol>

<h2>Step 3: Creating a Pie Chart Visualization in Kibana</h2>

<ol>
  <li>On the left panel, click on "Visualize". Then, click on the "+ Create Visualization" button.</li>
  <li>Choose the Pie chart visualization.</li>
  <li>Select the appropriate index pattern that you want to visualize.</li>
  <li>Under buckets, click "Split Slices." Select the field you want to analyze. For instance, if you want to visualize the distribution of gender, select "gender.keyword" in the field.</li>
  <li>Click on "run" (play icon) at the top of the page to view your visualization.</li>
</ol>

<p>You can create other visualization types similarly by choosing various chart types (Line, Bar, Heat Map, etc.) under the chart selection in step 2.</p>

<p>Remember, these are general steps, and depending on the data present in Elasticsearch, some visualizations might not make sense if the data is not suited for that type of visualization.</p>

<p>Also, as this guide focuses on using Kibana for visualization, please ensure you have appropriate access permissions and data privacy protocols in place since exposure trace and health-related data can be sensitive.</p>

<p><strong>Please note that the Logstash configuration provided includes a "sentiment" filter. The "sentiment" filter is not a default plugin for Logstash and requires custom plugins or solutions which are beyond the scope of this walkthrough.</strong></p>

<p><strong>Also, note this guide assumes you have Kibana, Logstash, and Elasticsearch installed and connected correctly on your system.</strong></p>
