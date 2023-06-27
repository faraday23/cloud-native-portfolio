<html>
  <head>
    <title>DevOps Case Study</title>
  </head>
  <body>
    <h1>Situation</h1>
    <p>
      As a DevOps engineer, I was tasked with overseeing the deployment and maintenance of a complex web application hosted on an Azure Kubernetes Service (AKS) cluster. This application was made up of several microservices such as user management, claims management, and plan management. The application used Azure Active Directory for user authentication, with security measures implemented via Azure Virtual Network and Network Security Groups. Load balancing for our high-traffic application was achieved through Azure Load Balancer with Nginx, while data was stored on Azure MySQL Flex Server, ensuring availability and scalability. The performance of the web application was monitored via Azure Monitor, and Docker images were stored and managed in Azure Container Registry. The entire application was built using the CI/CD model in a GitHub Actions pipeline.
    </p>
    
    <h1>Task</h1>
    <p>
      My primary responsibility was to ensure effective monitoring of all the components of our web application, with a particular focus on the user, claims, and plan management microservices, while maintaining high uptime and addressing any issues that arise.
    </p>
    
    <h1>Action</h1>
    <p>
      Aware of its capabilities, I decided to integrate Prometheus in our AKS cluster for in-depth monitoring. I installed Prometheus as a dedicated deployment within our AKS cluster and configured it with service discovery rules to scrape metrics from the application's microservices. I leveraged Prometheus's powerful query language for time series data to gain a deeper understanding of the microservices' performance. Also, to make it easy to interpret the metrics, I visualized them using Grafana, which is integrated with Prometheus data.
    </p>
    
    <h1>Issue/Problem</h1>
    <p>
      During the first few weeks, an unusual pattern was observed - the user management microservice had periodic high latency spikes, which adversely impacted the user experience. This issue was not detectable with Azure Monitor because it does not provide detailed insight into application-level issues, unlike Prometheus.
    </p>
    
    <h1>Resolution</h1>
    <p>
      I used the observability provided by Prometheus to analyze the pattern of these latency spikes. I discovered that they were occurring during peak usage times, due to overloading of the user management microservice. By adjusting the scaling rules for the AKS autoscaler based on these Prometheus metrics, I was able to ensure that the user management microservice automatically scaled up additional pods during periods of peak user load.
    </p>
    
    <h1>Result</h1>
    <p>
      After implementing these changes, the latency issue with the user management microservice was effectively mitigated. The Prometheus-Grafana setup provided us with increased visibility into our microservices' performances, allowing us to detect and tackle such issues proactively. As an outcome, we succeeded in improving the user experience and maintaining high uptime for our services.
    </p>
  </body>
</html>