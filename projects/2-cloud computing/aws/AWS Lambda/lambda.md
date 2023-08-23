<h2><b>Situation:</b></h2>
<p>
In my previous role at a financial tech startup, we built a system that processed thousands of financial transactions daily. The processing was initially done using a monolithic architecture on EC2 instances. As the volume of transactions grew, we started facing challenges in terms of scalability, cost, and agility in deploying updates.
</p>

<h2><b>Task:</b></h2>
<p>
I was given the responsibility of redesigning this processing system to be more scalable, cost-effective, and capable of deploying frequent updates without disruptions.
</p>

<h2><b>Action:</b></h2>
<p>
Considering the event-driven nature of our processing tasks and the potential to break down the monolithic design into smaller functions, I chose AWS Lambda as a suitable solution. My approach involved:
</p>
<ol>
    <li>Breaking down the monolithic application into smaller, functional components that could be handled by individual Lambda functions.</li>
    <li>Designing a new architecture where incoming transactions triggered Lambda functions through Amazon SNS (Simple Notification Service) and SQS (Simple Queue Service).</li>
    <li>Setting up a CI/CD pipeline using AWS CodePipeline and CodeBuild, allowing for seamless deployments of updates to the Lambda functions.</li>
    <li>Configuring proper monitoring using Amazon CloudWatch to keep track of function executions, errors, and performance metrics.</li>
</ol>

<h2><b>Issue:</b></h2>
<p>
A few weeks after the migration, we noticed that some transactions were not being processed. Upon further inspection, we discovered that the Lambda functions were occasionally timing out, especially during peak times.
</p>

<h2><b>Resolution:</b></h2>
<p>
To address this:
</p>
<ol>
    <li>I analyzed the execution logs in CloudWatch and identified that some functions were making external API calls, which were sometimes slow to respond.</li>
    <li>Implemented a retry mechanism using SQS Dead Letter Queues to ensure that failed transactions due to timeouts would be reprocessed.</li>
    <li>Optimized the Lambda function's code to reduce unnecessary operations, which helped in reducing the execution time.</li>
    <li>Adjusted the timeout setting and allocated more memory to the Lambda functions, which also improved the execution time.</li>
</ol>

<h2><b>Result:</b></h2>
<p>
After implementing these changes:
</p>
<ol>
    <li>The system became highly scalable, able to process a growing number of transactions without manual scaling intervention.</li>
    <li>We achieved significant cost savings as we only paid for the compute time we consumed with Lambda, unlike the always-on EC2 instances.</li>
    <li>The agility of our deployments improved, allowing for faster feature rollouts and patches.</li>
    <li>The timeout issues were effectively mitigated, ensuring a more consistent and reliable transaction processing experience for our users.</li>
    <li>With the new architecture, our team had the flexibility to update individual components without affecting the entire system, leading to faster development cycles and increased innovation.</li>
</ol>
