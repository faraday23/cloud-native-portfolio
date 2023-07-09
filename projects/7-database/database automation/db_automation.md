<!DOCTYPE html>
<html>

<head>
  <title>Electricity Bill Payment System</title>
</head>

<body>
  <h1>Situation</h1>
  <p>I was tasked with building an electricity bill payment system for a local utility company using MySQL and Django, a Python web framework. The system was required to store electricity bill information including customers, meters, readings, tariffs, bills, payments, etc. and provide a user interface for both the employees and the customers to interact with the data.</p>

  <h1>Task</h1>
  <p>My task was to design and implement a robust, scalable, and efficient database schema using MySQL to store all the necessary information. I was also responsible for creating the necessary SQL queries to perform CRUD operations on the data, such as generating bills, applying discounts, calculating dues, etc. Furthermore, I was to use Django to create the front-end interface where customers could log in to view their bills and make payments and employees could manage customer information, meter readings, tariffs, and payments.</p>

  <h1>Action</h1>
  <ol>
    <li>First, I gathered all the necessary requirements and specifications of the system. I collaborated with stakeholders to understand the full scope of the project and the data that needed to be stored and managed.</li>
    <li>I then proceeded to design a logical database schema. I identified the main entities such as customers, meters, readings, tariffs, bills, and payments, and the relationships between them. I ensured that each table had a primary key for identification and foreign keys to represent relationships between entities.</li>
    <li>I normalized the database to reduce data redundancy and improve data integrity, following the rules of first, second, and third normal forms.</li>
    <li>I translated this logical schema into a physical schema in MySQL, creating tables with necessary constraints to ensure data validity.</li>
    <li>I then wrote a series of SQL queries for CRUD operations and implemented views, functions, and triggers in MySQL for data customization and simplifying complex queries.</li>
    <li>Concurrently, I started building the web application using Django. I made use of Django's ORM capabilities to interact with the MySQL database and created necessary views, templates, and forms to create the front-end interface. I also implemented user authentication to provide secure login for customers and employees.</li>
    <li>I thoroughly tested the system and fixed any bugs or issues that came up during testing.</li>
  </ol>

  <h1>Issue/Problem</h1>
  <p>The main challenge that I faced during this project was dealing with concurrent transactions, especially when customers were making payments. The issue was to ensure data consistency and prevent race conditions where two or more customers might be trying to pay their bills at the same time, leading to incorrect updates to the database.</p>

  <h1>Resolution</h1>
  <p>I resolved this problem by implementing transaction isolation and locking mechanisms provided by MySQL. I ensured that whenever a payment was made, the database would lock the corresponding records, process the transaction, and then release the locks. This way, even if multiple customers were trying to make payments at the same time, each transaction would be processed independently without affecting the others.</p>

  <h1>Result</h1>
  <p>As a result, I was able to successfully build a robust, efficient, and user-friendly electricity bill payment system. The system was able to handle all necessary operations such as generating bills, applying discounts, calculating dues, etc., and provide an intuitive interface for customers and employees. The stakeholders were satisfied with the outcome, and the system was implemented successfully. This project not only helped

 me hone my technical skills in MySQL and Django but also helped me understand the practical aspects of building a complete, functional web application.</p>

</body>

</html>