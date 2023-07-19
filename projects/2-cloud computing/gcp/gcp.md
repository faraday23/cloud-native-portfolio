<h1>Task:</h1>
<p>The web application would allow customers to view and manage their insurance plans, claims, and personal information. The web application would also provide analytics and insights on the customers' health and wellness.</p>

<h1>Action:</h1>
<p>I proposed to use the following GCP services to build the web application:</p>

<ol>
  <li><strong>Google Kubernetes Engine (GKE)</strong> to host the web application in a containerized environment and to manage the scalability and availability of the application.</li>
  <li><strong>Cloud Run</strong> to deploy and run some of the microservices of the web application, such as user management, claims management, and plan management, as serverless functions.</li>
  <li><strong>Cloud SQL for MySQL</strong> to store and manage the relational data of the web application, such as customer information, plan details, and claim records.</li>
  <li><strong>Cloud Storage</strong> to store and serve static files of the web application, such as images, stylesheets, and scripts.</li>
  <li><strong>Firebase Authentication</strong> to authenticate the users of the web application using their Google accounts or email/password credentials.</li>
  <li><strong>Cloud Load Balancing</strong> to distribute the traffic of the web application across multiple instances of GKE and Cloud Run services and to provide high performance and availability.</li>
  <li><strong>Cloud CDN</strong> to cache and deliver the static content of the web application from edge locations near the users and to reduce latency and bandwidth costs.</li>
  <li><strong>Cloud Monitoring</strong> to monitor the health and performance of the web application and its components and to alert me of any issues or anomalies.</li>
  <li><strong>Cloud Build</strong> to automate the continuous integration and delivery of the web application code from GitHub to GKE and Cloud Run using Docker images.</li>
</ol>

<p>This is just a skeleton. In the following steps, I'll elaborate on how to define each resource.</p>

<h2>Step 1: Google Kubernetes Engine (GKE)</h2>

<p>To create a GKE cluster, we use the <code>google_container_cluster</code> resource. This resource requires a few parameters like the name, location, and the node configuration.</p>

<p><code>resource "google_container_cluster" "primary" {<br>
  name     = "my-gke-cluster"<br>
  location = "us-central1"<br>
<br>
  remove_default_node_pool = true<br>
  initial_node_count       = 1<br>
<br>
  master_auth {<br>
    username = ""<br>
    password = ""<br>
<br>
    client_certificate_config {<br>
      issue_client_certificate = false<br>
    }<br>
  }<br>
}</code></p>

<p>This configuration creates a GKE cluster with one node in the <code>us-central1</code> region. The <code>master_auth</code> block configures the Kubernetes master. Here we disable basic authentication and client certificate issuance.</p>

<h2>Step 2: Google Cloud Run</h2>

<p>Cloud Run is a managed compute platform that enables you to run stateless containers. To create a Cloud Run service, we use the <code>google_cloud_run_service</code> resource.</p>

<p><code>resource "google_cloud_run_service" "default" {<br>
  name     = "my-cloud-run-service"<br>
  location = "us-central1"<br>
<br>
  template {<br>
    spec {<br>
      containers {<br>
        image = "gcr.io/cloudrun/hello"<br>
      }<br>
    }<br>
  }<br>
<br>
  traffic {<br>
    percent         = 100<br>
    latest_revision = true<br>
  }<br>
}</code></p>

<p>This configuration creates a Cloud Run service in the <code>us-central1</code> region with the "hello" image from Google Cloud Registry.</p>

<h2>Step 3: Google Cloud SQL for MySQL</h2>

<p>To create a Cloud SQL instance, we use the <code>google_sql_database_instance</code> resource. This resource requires parameters such as the name, database version, region, and settings for the database instance.</p>

<p><code>resource "google_sql_database_instance" "default" {<br>
  name             = "my-db-instance"<br>
  database_version = "MYSQL_5_7"<br>
  region           = "us-central1"<br>
<br>
  settings {<br>
    tier = "db-f1-micro"<br>
<br>
    backup_configuration {<br>
      enabled = true<br>
    }<br>
  }<br>
}</code></p>

<p>This configuration creates a MySQL instance in the <code>us-central1</code> region with the smallest available tier <code>db-f1-micro</code>. Backups are enabled for this instance.</p>

<h2>Step 4: Google Cloud Storage</h2>

<p>To create a Cloud Storage bucket, we use the <code>google_storage_bucket</code> resource. This resource requires a name and a location.</p>

<p><code>resource "google_storage_bucket" "default" {<br>
  name     = "my-storage-bucket"<br>
  location = "US"<br>
}</code></p>

<p>This configuration creates a Cloud Storage bucket in the <code>US</code> multi-region location.</p>

<h2>Step 5: Firebase Authentication</h2>

<p>As of my knowledge cutoff in September 2021, Firebase resources are not directly manageable through Terraform. They are generally managed through the Firebase console or Firebase CLI.</p>

<h2>Step 6: Google Cloud Load Balancer</h2>

<p>To set up a Google Cloud Load Balancer, you typically need to create several resources: a backend service, a health check, a URL map, a target HTTP proxy, a global forwarding rule, etc. Here is an example of creating a global forwarding rule, which is one of the final steps in setting up a load balancer.</p>

<p><code>resource "google_compute_global_forwarding_rule" "default" {<br>
  name       = "my-forwarding-rule"<br>
  target     = google_compute_target_http_proxy.default.self_link<br>
  port_range = "80"<br>
}</code></p>

<p>In this example, the forwarding rule is associated with an HTTP proxy (not shown here) and listens on port 80.</p>

<h2>Step 7: Google Cloud CDN</h2>

<p>To use Cloud CDN, you need to enable it on a backend bucket or a backend service. Here's an example of creating a backend bucket with Cloud CDN enabled.</p>

<p><code>resource "google_compute_backend_bucket" "default" {<br>
  name        = "my-backend-bucket"<br>
  bucket_name = google_storage_bucket.default.name<br>
  enable_cdn  = true<br>
}</code></p>

<p>In this example, the backend bucket is associated with the previously created Cloud Storage bucket, and Cloud CDN is enabled on it.</p>

<h2>Step 8: Google Cloud Monitoring</h2>

<p>To create a Cloud Monitoring alert policy, we use the <code>google_monitoring_alert_policy</code> resource. This resource requires parameters such as the display name, the conditions under which the alert should be triggered, etc.</p>

<p><code>resource "google_monitoring_alert_policy" "default" {<br>
  display_name = "my-alert-policy"<br>
  combiner     = "OR"<br>
<br>
  conditions {<br>
    display_name = "my-condition"<br>
<br>
    condition_threshold {<br>
      filter = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""<br>
<br>
      duration = "60s"<br>
<br>
      comparison = "COMPARISON_GT"<br>
<br>
      threshold_value = 0.8<br>
<br>
      trigger {<br>
        count = 1<br>
      }<br>
    }<br>
  }<br>
}</code></p>

<p>In this example, an alert policy is created that triggers when CPU utilization of any GCE instance is greater than 80% for a duration of 60 seconds.</p>

<h2>Step 9: Google Cloud Build</h2>

<p>To create a Cloud Build trigger, we use the <code>google_cloudbuild_trigger</code> resource. This resource requires parameters such as the trigger template (repository and branch name) and the build instructions.</p>

<p><code>resource "google_cloudbuild_trigger" "default" {<br>
  name = "my-trigger"<br>
<br>
  github {<br>
    owner = "my-github-account"<br>
    name  = "my-repo"<br>
    push {<br>
      branch = "^master$"<br>
    }<br>
  }<br>
<br>
  build {<br>
    step {<br>
      name = "gcr.io/cloud-builders/docker"<br>
      args = ["build", "-t", "gcr.io/$PROJECT_ID/my-image", "."]<br>
    }<br>
  }<br>
}</code></p>

<p>In this example, a Cloud Build trigger is created that initiates a Docker build whenever there is a push to the <code>master</code> branch of the specified GitHub repository.</p>

<p>That covers most of your requested resources. Please replace all the placeholders like <code>&lt;your_project_id&gt;</code> with your actual project details. Also, remember that actual deployments might require more configurations like networking, IAM roles, etc., which are not covered in this walkthrough.</p>

<p>Let's continue with the deployment of these resources.</p>

<h2>Step 10: Deploying the resources</h2>

<p>Once you have defined all your resources in your .tf files, you can start deploying them. Here are the commands you would use to deploy your resources:</p>

<ol>
  <li><strong>Initialize your Terraform workspace</strong>: This will download the necessary provider plugins.</li>
  <code>terraform init</code>
  <li><strong>Validate your Terraform files</strong>: This will check your .tf files for syntax errors.</li>
  <code>terraform validate</code>
  <li><strong>Create a plan</strong>: This will show you what actions Terraform will perform.</li>
  <code>terraform plan</code>
  <li><strong>Apply the changes</strong>: This will create the resources. Terraform will ask for confirmation before making any changes.</li>
  <code>terraform apply</code>
</ol>

<h2>Step 11: Managing your resources</h2>

<p>Once your resources are deployed, you can manage them by modifying your .tf files and re-running <code>terraform apply</code>. For example, if you wanted to change the instance type of your Cloud SQL database, you would modify the <code>settings</code> block of your <code>google_sql_database_instance</code> resource and then re-run <code>terraform apply</code>.</p>

<p>You can also destroy your resources when you're done with them by running <code>terraform destroy</code>. This will delete all resources managed by your Terraform files.</p>

<h2>Step 12: Secure your Terraform deployment</h2>

<p>Remember to secure your Terraform deployment by:</p>

<ul>
  <li>Using version control to manage your .tf files.</li>
  <li>Ignoring files that contain sensitive information (like the <code>terraform.tfstate</code> file) in your .gitignore file.</li>
  <li>Using encrypted remote state storage.</li>
  <li>Using input variables for sensitive information and setting them through environment variables or a .tfvars file that's ignored by your version control system.</li>
</ul>