<!DOCTYPE html>
<html>
<head>
  <title>DevOps Engineer Experience</title>
</head>
<body>
  <h1>Situation:</h1>
  <p>I was working as a devops engineer for a company that developed a PHP application for microservices using Laravel and MySQL. The application consisted of several microservices that communicated with each other through REST APIs.</p>
  
  <h1>Task:</h1>
  <p>My task was to implement a CI/CD pipeline for the application using GitLab. The pipeline had to support automated builds, tests, code quality checks, containerization, and deployments to different environments.</p>
  
  <h1>Action:</h1>
  <p>I used GitLab to create pipelines for each microservice in the monorepo. Each pipeline was triggered by a push or merge request event on the main branch. The pipeline stages included the following:</p>
  
  <ol>
    <li>Build: Build the code and run unit tests using Composer and PHPUnit.</li>
    <li>Test: Run code quality checks using PHP_CodeSniffer and PHPStan.</li>
    <li>Package: Build and push Docker images to GitLab Container Registry using Docker commands.</li>
    <li>Deploy: Deploy the Docker images to Kubernetes clusters using GitLab Kubernetes integration.</li>
  </ol>
  
  <h1>Issue/Problem:</h1>
  <p>One of the challenges I faced was how to manage the configuration settings for different environments. The application had some settings that varied depending on the environment, such as database credentials, API keys, and feature flags. I did not want to hardcode these settings in the code or store them in plain text files.</p>
  
  <h1>Resolution:</h1>
  <p>I solved this problem by using GitLab CI/CD variables and Kubernetes secrets. Variables are placeholders that can be replaced with different values depending on the environment or other conditions. Secrets are encrypted values that can be stored in GitLab or Kubernetes and accessed by the pipelines or pods. I defined variables for each configuration setting in GitLab, and assigned them different values for each environment. I also used variable scoping to limit the scope of variables to specific environments or stages. Then, I used Kubernetes secrets to store the variables in Kubernetes clusters, and mounted them as environment variables or files in the pods.</p>
  
  <h1>Result:</h1>
  <p>As a result of my actions, I was able to implement a reliable and scalable CI/CD pipeline for the PHP application using GitLab. The pipeline improved the speed and quality of software delivery, as well as the collaboration between development and operations teams. The pipeline also reduced manual errors and ensured consistency across environments by using variables and secrets for configuration settings.</p>
</body>
</html>
