<h2><b>Situation:</b></h2>
<p>
In my previous role at a logistics company, we had a system that tracked packages in real-time, sending notifications to customers when their package status changed (e.g., "Out for Delivery," "Delivered"). Originally, these notifications were processed by our main application server, causing performance bottlenecks, especially during peak delivery times.
</p>

<h2><b>Task:</b></h2>
<p>
I was given the mandate to decouple the notification process from the main application, ensuring that notifications were sent in real-time without affecting the performance of our core services.
</p>

<h2><b>Action:</b></h2>
<p>
Given the event-driven nature of the notifications, I decided that Azure Functions, with its serverless compute model, would be an ideal solution. My actions included:
</p>
<ol>
    <li>Designing an Azure Function that would be triggered whenever a package status change was detected in our database.</li>
    <li>Implementing logic in the function to fetch user contact details and send appropriate notifications via email or SMS.</li>
    <li>Integrating Azure Service Bus to queue notification requests, ensuring that even during surges, every notification would be processed.</li>
    <li>Setting up Application Insights for monitoring and logging the function's performance.</li>
</ol>

<h2><b>Issue:</b></h2>
<p>
After deploying the Azure Function, while most notifications were processed in real-time, we noticed occasional delays. On further investigation, it was found that the function sometimes took longer to start after being idle, a phenomenon known as "cold start."
</p>

<h2><b>Resolution:</b></h2>
<p>
To address the cold start issue:
</p>
<ol>
    <li>I switched from a consumption plan to a premium plan for Azure Functions, which offers better performance and eliminates cold starts.</li>
    <li>Optimized the function code to reduce initialization overhead.</li>
    <li>Pre-warmed the function instances during expected peak times to ensure they were ready to handle incoming requests.</li>
    <li>Implemented fine-grained monitoring to track function execution times and catch any anomalies.</li>
</ol>

<h2><b>Result:</b></h2>
<p>
With these changes:
</p>
<ol>
    <li>Notifications were sent to customers in near real-time, enhancing their experience and trust in our service.</li>
    <li>The main application server's performance improved, as the load of processing notifications was offloaded.</li>
    <li>The serverless model of Azure Functions ensured cost optimization, as we only paid for the actual compute used.</li>
    <li>The system's overall reliability and performance improved, leading to positive feedback from both internal stakeholders and customers.</li>
</ol>
