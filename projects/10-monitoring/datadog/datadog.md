<!DOCTYPE html>
<html>
<head>
  <title>Datadog Configuration</title>
</head>
<body>
  <h1>Configuring Datadog for Incident Management and Synthetic Tests</h1>
  <p>
    My task was to configure Datadog for incident management and create synthetic tests for the web application. I had to use Datadog's integrations with Kubernetes and Azure Monitor to collect metrics, logs, and traces from the AKS cluster and the web application. I also had to use Datadog's synthetic tests to create HTTP checks and browser tests to simulate user requests and interactions with the web application. I also had to use Datadog's incident management features to set up escalation policies and on-call schedules for the devops team.
  </p>

  <h2>1. Installed Datadog Agent in AKS:</h2>

  <pre>
    <code>
      helm install datadog stable/datadog \
      --set traceAgent.enabled=true \
      --set logsAgent.enabled=true
    </code>
  </pre>

  <h2>2. Connected Datadog to Kubernetes and Azure:</h2>

  <pre>
    <code>
      apiVersion: datadoghq.com/v1alpha1
      kind: Integration 
      metadata:
        name: azure
      spec:
        azureMonitor:
          subscriptionId: &lt;ID&gt;
          resourceGroup: &lt;group&gt;
    </code>
  </pre>

  <h2>3. Instrumented app to send logs/traces to Datadog:</h2>

  <pre>
    <code>
      from ddtrace import trace

      @trace()
      def some_function():
         ...

      import logging
      logger = logging.getLogger('datadog.logs')
      logger.info('Some log message')  
    </code>
  </pre>

  <h2>4. Created HTTP synthetic checks:</h2>

  <pre>
    <code>
      # In Datadog UI
      - Name: API check 
      - URL: /api/endpoint  
      - Frequency: Every 1 minute
    </code>
  </pre>

  <h2>5. Created browser synthetic tests:</h2>

  <pre>
    <code>
      # Using Datadog recorder extension
      - Recorded steps:
        - Navigate to /users
        - Check title contains "Users"  
      - Assertions: Page load time &lt; 3s
    </code>
  </pre>

  <h2>6. Set up on-call rotation:</h2>

  <pre>
    <code>
      escalation_policy:
        # PagerDuty integration
        service: &lt;PD service&gt;
        phases:
          # Notify team A
          - notification_plan: team_a
            duration: 5m
          # Notify team B
          - notification_plan: team_b
    </code>
  </pre>

  <p>
    Hope this detailed breakdown helps! Let me know if you have any other questions.
  </p>
</body>
</html>
