<!DOCTYPE html>
<html>
<head>
  <title>Grafana Integration</title>
</head>
<body>
  <h1>Integrating Grafana with Existing System</h1>
  <p>
    My task was to integrate Grafana, an open-source platform for real-time monitoring and analytics, with our current system. The goal was to establish a comprehensive visualization dashboard, which would help us in application observability, troubleshooting, and real-time monitoring.
  </p>

  <h2>1. Setting up Grafana using Helm:</h2>

  <p>
    Begin by installing Helm, which is a package manager for Kubernetes. Once Helm is installed, you can set Grafana up using its Helm chart:
  </p>

  <pre>
    <code>
      # Add the helm stable repo
      helm repo add stable https://charts.helm.sh/stable

      # Update helm repositories
      helm repo update

      # Install Grafana
      helm install [RELEASE_NAME] stable/grafana --namespace [NAMESPACE]
    </code>
  </pre>

  <h2>2. Configure Grafana to connect Azure Monitor and MySQL:</h2>

  <p>
    You can set up a data source in Grafana's configuration to get metrics from Azure Monitor and MySQL. You would need your Azure Monitor API details and MySQL connection details (host, user, password, database).
  </p>

  <p>
    Add the following files in your Helm config to connect to these resources:
  </p>

  <p>For Azure Monitor example configuration:</p>

  <pre>
    <code>
      datasources:
        datasources.yaml:
          apiVersion: 1
          datasources:
          - name: Azure Monitor
            type: grafana-azure-monitor-datasource
            access: proxy
            isDefault: false
            editable: true
            version: 1
            jsonData:
              cloudName: azuremonitor
              subscriptionId: &lt;your-subscription-id&gt;
              tenantId: &lt;your-tenant-id&gt;
              clientId: &lt;your-client-id&gt;
              clientSecret: &lt;your-client-secret&gt;
              logAnalyticsDefaultWorkspace: &lt;your-default-workspace&gt;
            secureJsonFields:
              clientSecret: true
    </code>
  </pre>

  <p>For MySQL Database example configuration:</p>

  <pre>
    <code>
      datasources:
        datasources.yaml:
          apiVersion: 1
          datasources:
          - name: MySQL
            type: mysql
            url: &lt;your-mysql-host&gt;:&lt;your-mysql-port&gt;
            access: proxy
            isDefault: false
            database: &lt;database-name&gt;
            user: &lt;user-name&gt;
            secureJsonData:
              password: &lt;your-password&gt;
    </code>
  </pre>

  <p>
    Note: You need to replace the placeholders such as &lt;your-subscription-id&gt; and &lt;your-client-id&gt; with your real data. You can integrate these into your Grafana Helm installation using a values file.
  </p>

  <h2>3. Connect Grafana to Prometheus:</h2>

  <p>
    Having Prometheus as another data source can help you visualize your microservices' metrics. Here's how to include it in your Grafana instance:
  </p>

  <p>
    Add the following in your Helm values.yaml file and install the Grafana Helm chart:
  </p>

  <pre>
    <code>
      datasources:
        datasources.yaml:
          apiVersion: 1
          datasources:
          - name: Prometheus
            type: prometheus
            url: http://&lt;prometheus-service-name&gt;.&lt;namespace&gt;:9090
            access: proxy
    </code>
  </pre>

  <h2>4. Creating visualization dashboards:</h2>

  <p>
    Grafana allows creating visualization dashboards to showcase parameters like API response time, request rate, etc.
  </p>

  <ul>
    <li>You can use the <strong>import</strong> functionality in Grafana to fetch pre-built dashboards from Grafana’s website.</li>
    <li>Or you can create a new dashboard by clicking on <strong>+</strong> (Plus) then <strong>Dashboard</strong> -> <strong>Add New Panel</strong> -> and then write your Prometheus query to get visualization.</li>
  </ul>

  <p>
    Please replace <code>[RELEASE_NAME]</code> and <code>[NAMESPACE]</code> with your own values. Additionally, the Prometheus URL should be the endpoint where your Prometheus server can be accessed. This outline provides an overview and needs to be adjusted as per the specific needs of your setup, including enabling authentication, handling secrets, managing access control, and more.
  </p>
</body>
</html>
