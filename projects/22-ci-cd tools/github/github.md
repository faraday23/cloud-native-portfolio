<!DOCTYPE html>
<html>
<head>
  <title>DevOps Engineer Experience</title>
</head>
<body>
  <h1>Situation:</h1>
  <p>I was working as a devops engineer for a company that developed a Java application for microservices using Spring Boot and MongoDB. The application consisted of several microservices that communicated with each other through REST APIs.</p>
  
  <h1>Task:</h1>
  <p>My task was to implement a CI/CD pipeline for the application using GitHub Actions. The pipeline had to support automated builds, tests, code quality checks, containerization, and deployments to different environments.</p>
  
  <h1>Action:</h1>
  <p>I used GitHub Actions to create workflows for each microservice in the monorepo. Each workflow was triggered by a push or pull request event on the main branch. The workflow steps included the following:</p>
  
  <ol>
    <li>Checkout the code from the repository.</li>
    <li>Set up Java and Maven environments.</li>
    <li>Build the code and run unit tests using Maven.</li>
    <li>Run code quality checks using SonarCloud.</li>
    <li>Build and push Docker images to Docker Hub using Docker actions.</li>
    <li>Deploy the Docker images to Kubernetes clusters using Kubectl and Helm actions.</li>
  </ol>
  
  <h1>Issue/Problem:</h1>
  <p>One of the challenges I faced was how to create separate workflows for each microservice in the monorepo, without duplicating code or configuration. I also wanted to avoid triggering unnecessary workflows for microservices that were not changed by a commit.</p>
  
  <h1>Resolution:</h1>
  <p>I solved this problem by using GitHub Actions reusable workflows. Now I reference an entire Actions workflow in another workflow, like if it were a single action. They allow me to define common steps and parameters in one workflow file, and then reference it from multiple workflow files. This way, I can avoid code duplication and maintain consistency across workflows. Reusable workflows also support path filters, so I can specify which microservices should trigger which workflows.</p>
  
  <h1>Result:</h1>
  <p>As a result of my actions, I was able to implement a reliable and scalable CI/CD pipeline for the Java application using GitHub Actions. The pipeline improved the speed and quality of software delivery, as well as the collaboration between development and operations teams. The pipeline also reduced manual errors and ensured consistency across environments by using Docker and Kubernetes.</p>
</body>
</html>
