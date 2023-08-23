<b>Situation:</b>
<p>
At my previous company, we had a microservices architecture for our flagship product, which had a growing user base. The services were initially deployed using EC2 instances and manual scaling, which was not only inefficient but also not cost-effective.
</p>

<b>Task:</b>
<p>
I was tasked with finding a more scalable, manageable, and cost-effective solution to manage our containerized applications, as well as integrate this solution into our existing CI/CD pipeline.
</p>

<b>Action:</b>
<p>
After evaluating various solutions, I decided to migrate our services to Amazon EKS due to its tight integration with AWS services, managed node groups, and the ability to easily scale. My steps included:
</p>
<ol>
    <li>Setting up an EKS cluster using AWS Management Console.</li>
    <li>Configuring VPC, Subnets, and IAM roles for EKS.</li>
    <li>Migrating our Docker containers to be compatible with Kubernetes deployments.</li>
    <li>Setting up Helm for package management on EKS.</li>
    <li>Integrating EKS with our CI/CD tools, ensuring that every code push would automatically build a Docker image, push it to ECR (Elastic Container Registry), and deploy it to EKS.</li>
    <li>Implementing auto-scaling using the Kubernetes Horizontal Pod Autoscaler and the Cluster Autoscaler for nodes.</li>
</ol>

<b>Issue:</b>
<p>
During the migration, we faced a significant issue. Some of our legacy microservices, which were stateful, faced persistent storage challenges when moved to EKS. EBS (Elastic Block Store) volumes that we tried to attach as persistent volumes to our pods were not dynamically provisioning as expected, causing some services to fail.
</p>

<b>Resolution:</b>
<p>
To address this, I:
</p>
<ol>
    <li>Reviewed our storage class configurations and identified misconfigurations in our dynamic provisioner setup.</li>
    <li>Integrated Amazon EFS (Elastic File System) for stateful sets which required shared persistent storage.</li>
    <li>For services that didn't require shared storage, I ensured that EBS volumes were correctly provisioned by fixing the storage class configurations.</li>
</ol>

<b>Result:</b>
<p>
After the migration and resolution of the storage issue:
</p>
<ol>
    <li>Our microservices were running more efficiently with automatic scaling based on demand.</li>
    <li>Deployment times reduced significantly due to the integration of EKS with our CI/CD pipeline.</li>
    <li>Overall infrastructure costs decreased since we were only provisioning resources as needed.</li>
    <li>The team was able to focus more on feature development rather than infrastructure management, leading to faster product iterations and happier customers.</li>
</ol>
