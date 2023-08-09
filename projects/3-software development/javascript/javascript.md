<h1>Migrating to Cloud-Native Architecture: My Journey</h1>

<h2>1. Analyzing the Existing Application</h2>
<p>During the initial stage, I looked at the current monolithic application and identified distinct areas of functionality that could be separated into independent microservices.</p>

<h2>2. Creating Microservices in Node.js</h2>
<p>I used Visual Studio Code to create new Node.js projects for each microservice. With Express.js, I was able to quickly define lightweight, expressive HTTP APIs. Here's an example of what I did:</p>

<br>

<pre>
<code>
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => res.send('Hello, world!'));

app.listen(port, () => console.log(`Server running on port ${port}`));
</code>
</pre>

<br>

<h2>3. Containerizing Microservices</h2>
<p>I created a <code>Dockerfile</code> to define how to build a Docker image of my microservice:</p>

<br>

<pre>
<code>
FROM node:16 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

FROM build AS final
EXPOSE 3000
CMD ["node", "server.js"]
</code>
</pre>

<br>

<h2>4. Deploying to Azure</h2>
<p>I deployed my Docker containers to Azure using Azure Container Instances (ACI) and Azure Kubernetes Service (AKS). For the deployment, I utilized Azure CLI and Azure PowerShell.</p>

<h2>5. Using Azure Services</h2>
<p>I made use of various Azure services as the backing services for my application:</p>
<ul>
  <li>Azure SQL Database or Azure Cosmos DB for data storage.</li>
  <br>
  <li>Azure Service Bus for message passing between microservices.</li>
  <br>
  <li>Azure Cache for Redis for caching.</li>
  <br>
  <li>Azure Application Insights for monitoring and diagnostics.</li>
</ul>

<h2>6. Ensuring Consistency Across Microservices</h2>
<p>To ensure consistency and reliability across microservices, I implemented the saga pattern using Azure Service Bus and Azure Durable Functions. Here's an example of how I defined a durable function to coordinate a saga:</p>

<br>

<pre>
<code>
const df = require('durable-functions');

module.exports = df.orchestrator(function* (context) {
    const transactionData = context.df.getInput();

    try {
        yield context.df.callActivity('PerformStep1', transactionData);
        yield context.df.callActivity('PerformStep2', transactionData);
        // Additional steps...
    } catch (error) {
        // Compensate for any completed transactions
        yield context.df.callActivity('CompensateStep1', transactionData);
        yield context.df.callActivity('CompensateStep2', transactionData);
        // Additional compensations...
    }
});
</code>
</pre>

<br>

<h2>7. Results and Feedback</h2>
<p>After successfully migrating the application to a cloud-native architecture using Node.js and Azure, I received positive feedback from my manager and clients for my work. This is a testament to the benefits of using cloud-native architectures and the capabilities of Node.js and Azure.</p>
