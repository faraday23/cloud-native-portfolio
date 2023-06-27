<!DOCTYPE html>
<html>
<head>
  <title>Functional Test Plan for Web Application</title>
</head>
<body>
  <h1>Situation:</h1>
  <p>
    I was asked to develop a functional test plan for a new web application that allows employees to manage their company benefits.
  </p>

  <h1>Task:</h1>
  <p>
    Develop and execute a functional test plan to ensure the application works as expected before releasing to production.
  </p>

  <h1>Action:</h1>
  <ol>
    <li>
      Created test cases for each user role and feature like claims submission, plan enrollment, etc.
    </li>
    <li>
      Designed test data covering success and error scenarios.
    </li>
    <li>
      Performed unit testing of individual microservices deployed as Docker containers.
    </li>
    <li>
      Conducted integration testing of the fully deployed application in the AKS cluster.
    </li>
    <li>
      Tested authentication and authorization with Azure AD.
    </li>
    <li>
      Validated behavior under different load conditions.
    </li>
    <li>
      Took nodes offline to ensure high availability.
    </li>
    <li>
      Created automated UI tests using Selenium to run repeatable test cases.
    </li>
    <li>
      Monitored application metrics and logs during testing.
    </li>
  </ol>

  <h1>Issue:</h1>
  <p>
    Without comprehensive testing, issues could impact customers after releasing to production.
  </p>

  <h1>Resolution:</h1>
  <p>
    I implemented a multi-phase test approach with unit, integration, load, stress, and UI automation testing. I created detailed test data and scenarios to thoroughly exercise the application's functionality.
  </p>

  <h1>Result:</h1>
  <p>
    By identifying and fixing issues before production, the application launch experienced high stability, improving customer satisfaction and reducing post-release bugs. Automated tests enabled continued regression testing during development, helping ensure high quality.
  </p>
</body>
</html>