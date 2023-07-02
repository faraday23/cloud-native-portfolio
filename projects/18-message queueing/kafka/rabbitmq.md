<!DOCTYPE html>
<html>

<head>
  <title>RabbitMQ Pub-Sub Task</title>
</head>

<body>
  <h1>Situation</h1>
  <p>I was hired as a devops engineer for a company that had a microservice architecture that needed to communicate asynchronously and reliably. The company wanted to use RabbitMQ as a message broker to implement a publisher-subscriber pattern with topic exchanges. The company also wanted to deploy and manage RabbitMQ on Azure Kubernetes Service (AKS), a managed service for running Kubernetes clusters on Azure.</p>

  <h1>Task</h1>
  <p>My task was to implement a pub-sub model with RabbitMQ on AKS. I had to create a topic exchange and bind multiple queues to it with different routing keys. I also had to create publishers and subscribers that send and receive messages based on the topics. I also had to deploy and manage RabbitMQ on AKS using Helm charts and kubectl commands. I also had to monitor and troubleshoot the pub-sub system using RabbitMQ management console and Azure CLI.</p>

  <h1>Action</h1>
  <ol>
    <li>I created an AKS cluster using Azure CLI and configured kubectl to connect to it. I also created a namespace for RabbitMQ and other resources.</li>
    <li>I installed RabbitMQ on AKS using Helm charts from Bitnami. I also enabled the RabbitMQ management plugin and exposed it as a load balancer service. I also created a secret for the RabbitMQ credentials and configured them in the Helm values file.</li>
    <li>I created a topic exchange named "news" and bound four queues to it with different routing keys. The routing keys were "sports.*", "entertainment.*", "business.*" and "*.breaking". The queues were named "sports-news", "entertainment-news", "business-news" and "breaking-news" respectively. I used the RabbitMQ management console to create the exchange and queues and bind them.</li>
    <li>I created publishers and subscribers using Python and Pika, a RabbitMQ client library. The publishers sent messages with different topics, such as "sports.football", "entertainment.movies", "business.stocks" and "world.breaking". The subscribers received messages based on the topics they subscribed to, such as "sports.*", "*.breaking", etc. I used the <b>basic_publish</b> and <b>basic_consume</b> methods of Pika to send and receive messages.</li>
    <li>I deployed the publishers and subscribers as Kubernetes deployments and services using kubectl commands. I also configured environment variables for the RabbitMQ credentials and host name in the deployment manifests. I also exposed the publishers and subscribers as load balancer services for testing purposes.</li>
    <li>I tested the pub-sub system by sending messages from different publishers and verifying that they were received by the appropriate subscribers based on the topics. I also used the RabbitMQ management console to monitor the message rates, queue lengths, bindings, etc.</li>
  </ol>

  <h1>Issue/Problem</h1>
  <p>One of the issues or problems that I faced during the task was how to handle network failures or connection losses between the publishers, subscribers and RabbitMQ. Network failures or connection losses can occur due to various reasons, such as network congestion, node failures, pod restarts, etc. For example, if a publisher lost connection to RabbitMQ while sending a message, the message could be lost or duplicated.</p>

  <h1>Resolution</h1>
  <p>To resolve this issue or problem:</p>
  <ol>
    <li>I decided to

 use message delivery guarantees and acknowledgements in RabbitMQ and Pika to handle network failures or connection losses gracefully and ensure that messages were delivered exactly once.</li>
    <li>I enabled publisher confirms by setting the <b>confirm_delivery</b> parameter of Pika's <b>channel.confirm_delivery</b> method to <b>True</b>. I also registered a callback function with Pika's <b>channel.add_on_publish_confirmation</b> method to handle publisher confirmations.</li>
    <li>I enabled consumer acknowledgements by setting the <b>no_ack</b> parameter of Pika's <b>channel.basic_consume</b> method to <b>False</b>. I also called Pika's <b>channel.basic_ack</b> method with the delivery tag of the message after processing it.</li>
    <li>I enabled message persistence by setting the <b>delivery_mode</b> parameter of Pika's <b>pika.BasicProperties</b> class to <b>2</b> (persistent). I also passed an instance of <b>pika.BasicProperties</b> with <b>delivery_mode</b> set to <b>2</b> as an argument of Pika's <b>channel.basic_publish</b> method.</li>
  </ol>

  <h1>Result</h1>
  <p>As a result of my actions, I was able to implement a pub-sub model with RabbitMQ on AKS. I was able to create a topic exchange and bind multiple queues to it with different routing keys. I was also able to create publishers and subscribers that send and receive messages based on the topics. I was also able to deploy and manage RabbitMQ on AKS using Helm charts and kubectl commands. I was also able to monitor and troubleshoot the pub-sub system using RabbitMQ management console and Azure CLI. I was also able to use message delivery guarantees and acknowledgements in RabbitMQ and Pika to handle network failures or connection losses gracefully and ensure that messages were delivered exactly once. I received positive feedback from my supervisor and client for my work on the task.</p>
</body>

</html>

