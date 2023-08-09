<h3>Step 1: Analyzing Requirements</h3>
<p><strong>Goal:</strong> I had to understand the requirements for the employee management system and identify entities, attributes, and relationships.</p>
<ul>
    <li><strong>Entities:</strong> I identified Employee, Department, Job Role, Employment History, Salary History.</li>
    <li><strong>Attributes:</strong> I listed Employee details (ID, name, contact), Job role, Department details, etc.</li>
    <li><strong>Relationships:</strong> I recognized Employee hierarchy, Department budgets, Salary history.</li>
</ul>
<p><strong>Entity-Relationship Diagram (ERD):</strong></p>
<ul>
    <li>I created an ERD to visualize the relationships between entities.</li>
</ul>

<h3>Step 2: Normalizing the Database Design</h3>
<p><strong>Goal:</strong> I applied normalization rules to eliminate redundancy and ensure data integrity.</p>
<ul>
    <li><strong>1NF:</strong> I removed repeating groups and duplicate data.</li>
    <li><strong>2NF:</strong> I ensured that all non-key attributes depended on the whole primary key.</li>
    <li><strong>3NF:</strong> I removed transitive dependencies.</li>
</ul>

<h3>Step 3: Translating to Physical Database Design (PostgreSQL)</h3>
<p><strong>Goal:</strong> I created tables, columns, constraints, and indexes using SQL DDL.</p>
<h4>Creating Tables:</h4>
<pre>
-- Employee Table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact VARCHAR(100),
    manager_id INT REFERENCES employees(employee_id),
    -- Other fields...
);

-- Department Table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    budget DECIMAL(10,2)
    -- Other fields...
);

-- Other tables as required...
</pre>

<h3>Step 4: Writing SQL Queries for Data Operations</h3>
<p><strong>Goal:</strong> I implemented CRUD operations (Create, Read, Update, Delete).</p>
<h4>Example Queries:</h4>
<ul>
    <li><strong>Inserting a new employee:</strong></li>
    <pre>
INSERT INTO employees (name, contact) VALUES ('John Doe', 'j.doe@example.com');
    </pre>
    <li><strong>Updating an employee's contact:</strong></li>
    <pre>
UPDATE employees SET contact = 'new.email@example.com' WHERE employee_id = 1;
    </pre>
    <li><strong>Deleting an employee:</strong></li>
    <pre>
DELETE FROM employees WHERE employee_id = 5;
    </pre>
</ul>

<h3>Step 5: Testing and Documenting</h3>
<p><strong>Goal:</strong> I verified the schema and queries, and documented using tools like pgAdmin and Markdown.</p>
<ul>
    <li>I tested each query to ensure correct behavior.</li>
    <li>I documented using comments, diagrams, and examples.</li>
</ul>

<h3>Issue: Implementing Employee Hierarchy</h3>
<p><strong>Challenge:</strong> I faced the challenge of representing hierarchical relationships between employees.</p>

<h3>Resolution: Using a Closure Table Approach</h3>
<h4>Steps to Implement Closure Table:</h4>
<ol>
    <li><strong>Create Closure Table:</strong></li>
    <pre>
CREATE TABLE employee_hierarchy (
    ancestor_id INT REFERENCES employees(employee_id),
    descendant_id INT REFERENCES employees(employee_id),
    depth INT,
    PRIMARY KEY (ancestor_id, descendant_id)
);
    </pre>
    <li><strong>Populate Closure Table:</strong></li>
    <pre>
-- Example of inserting data into the closure table
WITH RECURSIVE hierarchy AS (
    SELECT employee_id AS ancestor_id, employee_id AS descendant_id, 0 AS depth
    FROM employees
    UNION ALL
    SELECT h.ancestor_id, e.employee_id AS descendant_id, h.depth + 1
    FROM hierarchy h
    JOIN employees e ON h.descendant_id = e.manager_id
)
INSERT INTO employee_hierarchy SELECT * FROM hierarchy;
    </pre>
    <li><strong>Create Triggers to Sync Data:</strong></li>
    <pre>
-- Example trigger to update closure table on insert/update/delete
CREATE TRIGGER update_hierarchy
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW EXECUTE FUNCTION update_hierarchy_function();
    </pre>
</ol>

<h3>Result:</h3>
<ul>
    <li>I successfully designed and implemented a database schema for the employee management system.</li>
    <li>I implemented features like employee hierarchy using closure tables.</li>
    <li>I received positive feedback for the project.</li>
</ul>
<p>By following these steps and applying best practices, I designed the database to meet the requirements of the mid-sized company's employee management system. By using creative solutions like the closure table, I optimized the schema for querying and performance.</p>
