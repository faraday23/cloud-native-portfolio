<!DOCTYPE html>
<html>
<head>
  <title>Monitoring Setup</title>
</head>
<body>
  <h1>My Primary Responsibility</h1>
  <p>
    My primary responsibility was to ensure effective monitoring of all the components of our web application, with a particular focus on the user, claims, and plan management microservices, while maintaining high uptime and addressing any issues that arise.
  </p>

  <h2>1. Set Up an AKS Cluster (Azure Kubernetes Service):</h2>

  <p>
    First of all, ensure that you have an Azure account. You will need Azure CLI installed in your local system. If not installed you can download it <a href="https://docs.microsoft.com/en-us/cli/azure/install-azure-cli">here</a>.
  </p>

  <pre>
    <code>
      az login

      # create a resource group
      az group create --name MyResourceGroup --location eastus2

      # create AKS cluster
      az aks create --resource-group MyResourceGroup --name MyAKSCluster --node-count 3 --enable-addons monitoring --generate-ssh-keys
    </code>
  </pre>

  <h2>2. Install Prometheus in AKS:</h2>

  <p>
    This involves deploying the Prometheus server as a dedicated deployment within your AKS cluster. You can install Prometheus using the Prometheus Operator, which can be installed via Helm.
  </p>

  <pre>
    <code>
      # Add the helm stable repo
      helm repo add stable https://charts.helm.sh/stable

      # Update your helm repositories
      helm repo update

      # Install Prometheus Operator
      helm install [RELEASE_NAME] stable/prometheus-operator --namespace [NAMESPACE]
    </code>
  </pre>

  <h2>3. Configure Prometheus to Scrape Metrics:</h2>

  <p>
    This involves configuring Prometheus with service discovery rules to discover and scrape metrics from your application's microservices. Here's an example of a basic configuration. You need to amend it according to your needs and the services you want to monitor:
  </p>

  <pre>
    <code>
      scrape_configs:
        - job_name: 'microservice'
          kubernetes_sd_configs:
            - role: pod
          relabel_configs:
            - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
              action: keep
              regex: true
            - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
              action: replace
              target_label: __metrics_path__
              regex: (.+)
    </code>
  </pre>

  <h2>4. Configure Prometheus with Service Discovery Rules:</h2>

  <p>
    Configure Prometheus with service discovery rules to scrape metrics from the application's microservices. You can do this by creating ServiceMonitor resources that define how Prometheus should discover and scrape metrics from your microservices. To do this, follow these steps:
  </p>

  <ol>
    <li>
      Make sure your microservices expose metrics in a format that Prometheus can understand, such as Prometheus text format or OpenMetrics format. You can use libraries or exporters to instrument your code or expose metrics from third-party applications.
    </li>
    <li>
      Create a Service resource for each microservice that exposes metrics on a port. For example, if your user microservice exposes metrics on port 8080, you can create a Service like this:
      <pre>
        <code>
          apiVersion: v1
          kind: Service
          metadata:
            name: user-service
            labels:
              app: user
          spec:
            selector:
              app: user
            ports:
              - name: metrics
                port: 8080
                targetPort: 8080
        </code>
      </pre>
    </li>
    <li>
      Create a ServiceMonitor resource for each Service that defines how Prometheus should scrape metrics from it. For example, if you want Prometheus to scrape metrics from the user-service every 15 seconds, you can create a ServiceMonitor like this:
      <pre>
        <code>
          apiVersion: monitoring.coreos.com/v1
          kind: ServiceMonitor
          metadata:
            name: user-service-monitor
            labels:
              release: prometheus
          spec:
            selector:
              matchLabels:
                app: user
            endpoints:
              - port: metrics
                interval: 15s
        </code>
      </pre>
    </li>
  </ol>

  <h2>5. Leverage Prometheus's Powerful Query Language:</h2>

  <p>
    Leverage Prometheus's powerful query language for time series data to gain a deeper understanding of the microservices' performance. You can do this by using PromQL, which is a query language that allows you to manipulate and analyze time series data stored in Prometheus. To do this, follow these steps:
  </p>

  <ol>
    <li>
      Access the Prometheus web UI by running <code>kubectl port-forward svc/prometheus-server 9090:80</code> and opening <a href="http://localhost:9090">http://localhost:9090</a> in your browser.
    </li>
    <li>
      Use the expression browser to enter PromQL queries and see the results in graphs or tables. For example, you can enter <code>rate(http_requests_total[5m])</code> to see the rate of HTTP requests per second for each microservice in the last 5 minutes.
    </li>
    <li>
      Use the console templates to create custom dashboards that display the metrics you care about. For example, you can create a template like this to show the average response time and error rate for each microservice:
      <pre>
        <code>
          &lt;h1&gt;Microservice Performance&lt;/h1&gt;
          &lt;table&gt;
            &lt;tr&gt;
              &lt;th&gt;Microservice&lt;/th&gt;
              &lt;th&gt;Average Response Time (ms)&lt;/th&gt;
              &lt;th&gt;Error Rate (%)&lt;/th&gt;
            &lt;/tr&gt;
            {{ range query "sum by (app) (rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])) * 1000" }}
            &lt;tr&gt;
              &lt;td&gt;{{ .Labels.app }}&lt;/td&gt;
              &lt;td&gt;{{ .Value | printf "%.2f" }}&lt;/td&gt;
              &lt;td&gt;{{ (query (printf "sum by (app) (rate(http_requests_total{app=\"%s\",status!~\"2..\"}[5m])) / sum by (app) (rate(http_requests_total{app=\"%s\"}[5m])) * 100" .Labels.app .Labels.app)).0.Value | printf "%.2f" }}&lt;/td&gt;
            &lt;/tr&gt;
            {{ end }}
          &lt;/table&gt;
        </code>
      </pre>
    </li>
  </ol>

  <h2>6. Integrate Prometheus with Grafana:</h2>

  <p>
    After setting up Prometheus, you can now integrate it with Grafana for visualizing metrics. Grafana is also installed via Helm.
  </p>

  <pre>
    <code>
      # Install Grafana chart
      helm install [RELEASE_NAME] stable/grafana --namespace [NAMESPACE]

      # Obtain the Grafana admin password
      kubectl get secret --namespace [NAMESPACE] [RELEASE_NAME]-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

      # Port forward the Grafana pod
      export POD_NAME=$(kubectl get pods --namespace [NAMESPACE] -l "app=grafana,release=[RELEASE_NAME]" -o jsonpath="{.items[0].metadata.name}")
      kubectl --namespace [NAMESPACE] port-forward $POD_NAME 3000
    </code>
  </pre>

  <p>
    Now, you can add Prometheus as a data source in Grafana's dashboard:
  </p>

  <ol>
    <li>After logging into Grafana, click on <strong>Add data source</strong>.</li>
    <li>Select <strong>Prometheus</strong> as the data source type.</li>
    <li>Enter the URL of your Prometheus server and click <strong>Save & Test</strong>.</li>
  </ol>

  <p>
    You can start creating dashboards and panels for your application metrics.
  </p>

  <p>Please replace <code>[RELEASE_NAME]</code> and <code>[NAMESPACE]</code> with your own values. Keep in mind that these are broad steps and you have to tweak them according to your use case, including enabling authentication and other settings.</p>
</body>
</html>
