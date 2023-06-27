Datadog is a widely-used service that provides monitoring and analytics for cloud-based workflows. Here is a step-by-step guide on how to set up Datadog for server monitoring, including setting up agents, collecting metrics, and creating dashboards for visualization and analysis.

**1. Creating a Datadog Account:**

If you haven't already, start by signing up for a Datadog account at https://www.datadoghq.com/. The service offers a free trial for new accounts.

**2. Installing the Datadog Agent:**

The Datadog Agent is a piece of software that collects metrics, traces, logs, and more from your hosts and sends this data to Datadog. Install the agent on every host you want to monitor.

The exact command depends on your OS. On Ubuntu, the command is:

```bash
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=<your_datadog_api_key> DD_SITE="datadoghq.com" bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"
```

Replace `<your_datadog_api_key>` with your Datadog API key, which can be found in the Datadog app in Integrations > APIs.

**3. Configure the Agent:**

The Agent comes with numerous integrations for popular software and services. You can configure these integrations by modifying the appropriate configuration file in the `/etc/datadog-agent/conf.d/` directory.

For instance, if you want to monitor CPU usage, you would update the `system_core.yaml` file:

```yaml
init_config:

instances:
  - cpuacct_cpu_all: false
```

**4. Collecting Metrics:**

With the Agent installed and configured, it will automatically begin collecting and reporting metrics to Datadog. 

**5. Creating a Dashboard:**

To visualize your data:

- Navigate to Dashboards > New Dashboard in the Datadog app.
- Choose whether to create a time-based (Timeboard) or screen-based (Screenboard) dashboard.
- Give your dashboard a name and optionally a description.
- Click 'New Dashboard'.

Now you can add widgets to your dashboard to display various metrics:

- Click 'Add Widget'.
- Choose the type of widget you want to create (e.g., timeseries, heatmap, etc.).
- In the widget settings, select the metric you want to display and any additional configuration options.
- Click 'Done' to add the widget to the dashboard.

Repeat this process to add as many widgets as you need to fully monitor your servers.

**6. Setting Alerts:**

You can also set up alerts based on the metrics your Agent is collecting. To create a new alert:

- Navigate to Monitors > New Monitor in the Datadog app.
- Select the type of monitor you want to create (e.g., Metric Monitor).
- Define the conditions for the alert and what actions to take when the conditions are met.
- Click 'Save'.

This is a basic setup and may need to be adjusted based on your specific needs and the scale of your infrastructure.