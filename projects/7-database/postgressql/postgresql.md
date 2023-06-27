<h1>Situation</h1>
<p><strong>I was assigned to design and implement a database schema for an employee management system for a mid-sized company.</strong> The system needed to handle employee data like job role, department, contact details, employment history, etc. It also needed to implement features like employee hierarchy, employee salary history, and track department budgets.</p>

<h1>Task</h1>
<p><strong>My task was to create a logical and physical database design that met the requirements and specifications of the system.</strong> I also had to write SQL queries to perform various operations on the data, such as inserting, updating, deleting, and retrieving records. I also had to test and document the database schema and queries.</p>

<h1>Action</h1>
<p><strong>I followed these steps to complete the task:</strong></p>
<ol>
  <li>I analyzed the requirements and specifications of the system and identified the entities, attributes, and relationships involved in the employee management system. I used an entity-relationship diagram (ERD) to model the logical database design.</li>
  <li>I normalized the database design to reduce data redundancy and improve data integrity. I applied the rules of first, second, and third normal forms (1NF, 2NF, 3NF) to eliminate partial and transitive dependencies. I also considered other factors like performance, scalability, and maintainability in the database design.</li>
  <li>I translated the logical database design into a physical database design using PostgreSQL as the database management system (DBMS). I created tables, columns, primary keys, foreign keys, constraints, indexes, etc. using SQL Data Definition Language (DDL) commands. I also created views, functions, triggers, etc. using SQL Data Manipulation Language (DML) commands.</li>
  <li>I wrote SQL queries to perform various operations on the data, such as inserting, updating, deleting, and retrieving records. I used SQL clauses like WHERE, ORDER BY, GROUP BY, HAVING, LIMIT, OFFSET, etc. to filter, sort, group, and limit the data. I also used SQL features like joins, subqueries, common table expressions (CTEs), window functions, etc. to combine data from multiple tables and perform complex calculations on the data.</li>
  <li>I tested and documented the database schema and queries using tools like pgAdmin and Markdown. I verified that the database schema met the requirements and specifications of the system. I also checked that the queries returned the expected results and handled errors and exceptions properly. I documented the database schema and queries using comments, diagrams, examples, etc.</li>
</ol>

<h1>Issue/Problem</h1>
<p><strong>One of the issues or problems that I faced during the project was how to implement employee hierarchy in the database schema.</strong> Employee hierarchy is a recursive relationship where an employee can have one or more subordinates or managers. This can result in a complex query that involves multiple self-joins or recursive CTEs.</p>

<h1>Resolution</h1>
<p><strong>To resolve this issue or problem,</strong></p>
<p>I decided to use a closure table approach to store employee hierarchy in the database schema. A closure table is a table that stores all possible paths between nodes in a hierarchical structure. It has three columns: ancestor, descendant, and depth. Ancestor and descendant are foreign keys that reference the primary key of the employee table. Depth is an integer that indicates how many levels are between the ancestor and descendant nodes.</p>

<p>Using a closuretable approach has several advantages:</p>
<ol>
  <li>It simplifies querying employee hierarchy by avoiding multiple self-joins or recursive CTEs. A single join between the employee table and the closure table can retrieve all ancestors or descendants of a given employee.</li>
  <li>It improves query performance by reducing the number of joins and calculations required. A closure table can be indexed on ancestor, descendant, or depth columns to speed up query execution.</li>
  <li>It supports multiple hierarchies within a single table. A closure table can store different types of hierarchical relationships between employees, such as reporting, mentoring, or team membership.</li>
</ol>

<p>To implement a closure table approach,</p>
<p>I followed these steps:</p>
<ol>
  <li>I created a closure table called employee_hierarchy with three columns: ancestor_id, descendant_id, and depth. Ancestor_id and descendant_id were foreign keys that referenced the employee_id column of the employee table. Depth was an integer that indicated how many levels were between the ancestor and descendant nodes.</li>
  <li>I populated the closure table with data using a recursive CTE that traversed the employee hierarchy from top to bottom. For each employee, I inserted a row for themselves (depth = 0), their direct manager (depth = 1), their indirect managers (depth > 1), their direct subordinates (depth = -1), and their indirect subordinates (depth < -1).</li>
  <li>I created a trigger on the employee table that updated the closure table whenever an employee was inserted, updated, or deleted. The trigger ensured that the closure table was always in sync with the employee table and reflected the current state of the employee hierarchy.</li>
</ol>

<h1>Result</h1>
<p><strong>As a result of my actions,</strong></p>
<p>I was able to design and implement a database schema for an employee management system that met the requirements and specifications of the system. I was also able to write SQL queries to perform various operations on the data, such as inserting, updating, deleting, and retrieving records. I was also able to test and document the database schema and queries using tools like pgAdmin and Markdown. I was also able to implement employee hierarchy in the database schema using a closure table approach that simplified querying, improved performance, and supported multiple hierarchies. I received positive feedback from my supervisor and client for my work on the project.</p>