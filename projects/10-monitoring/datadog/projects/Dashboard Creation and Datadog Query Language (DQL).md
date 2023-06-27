**1. Building Custom Dashboards and Leveraging Datadog's Dashboard Templates:**

A dashboard is a collection of widgets that visually display real-time data and enable teams to monitor their infrastructure in real time. Datadog provides two types of dashboards:

- Timeboards: Display graphs in a time-series format.
- Screenboards: Offer more flexibility with free-form layouts and can display a combination of correlated metrics, traces, and logs data.

Here are the steps to create a custom dashboard:

a. Log into your Datadog account.
b. Navigate to the "Dashboards" section in the left sidebar and click on "New Dashboard."
c. Enter a name for your dashboard.
d. Choose whether you want it to be a Timeboard or a Screenboard.
e. Click on "New Dashboard" to create it.

Now, you can add widgets to the dashboard. The process for adding a widget to the dashboard is as follows:

i. Click on "Add Widget" on the dashboard.
ii. Choose the widget type that suits the data you want to represent. Datadog provides various types of widgets such as timeseries, heatmap, query value, etc.
iii. After selecting the widget, configure it with the data you want to display.
iv. Click on "Done" to add the widget to the dashboard.

Datadog also offers pre-built dashboards for many integrations. To use these templates, you need to:

i. Navigate to "Integrations" in the sidebar menu.
ii. Select an integration.
iii. On the integration's configuration page, select the "Install Integration" button.
iv. After the integration is installed, the dashboard will be added to your list of dashboards.

**2. Understanding Datadog Query Language (DQL) for Data Filtering and Aggregation:**

Datadog Query Language (DQL) is a syntax similar to SQL that you can use to create complex queries on your data in Datadog. With DQL, you can select, filter, and aggregate your data. 

Here is an example DQL query:

```
avg:system.cpu.user{*} by {host}
```

This query averages the `system.cpu.user` metric over all hosts, and then breaks it down by each individual host.

DQL also supports functions for more complex queries, such as `timeshift`, `rollup`, `rate`, `top`, and others. You can use these functions to manipulate your data in various ways.

**3. Visualizations and Dashboard Sharing Best Practices:**

Visualization best practices include:

- Choose the appropriate visualization for your data: Time series are best for showing data over time, while heatmaps are useful for showing distributions.
- Use consistent units and scales: This can help avoid confusion.
- Leverage color and styles: These can help distinguish different elements of your visualizations.
- Provide context: Always include a clear title and labels.

To share a dashboard:

- Go to the dashboard you want to share.
- Click on the "Share" button in the top right corner of the dashboard.
- You can then choose to send an email with the dashboard link, create a public URL, generate an embed code, or create a PDF file of the dashboard.

**4. Hands-on Exercise: Creating a Custom Dashboard with Various Visualizations Using DQL:**

a. Follow the steps in the first section to create a new dashboard.
b. Add a "Timeseries" widget to display a metric over time. For the DQL query, use something like: `avg:system.cpu.user{*} by {host}`.
c. Add a "Top List" widget to display the hosts with the highest CPU usage. For the DQL query, use something like: `top(avg

:system.cpu.user{*} by {host}, 10, 'mean', 'desc')`.
d. Add a "Heatmap" widget to show the distribution of CPU usage. For the DQL query, use something like: `avg:system.cpu.user{*}`.
e. Once you are satisfied with your dashboard, share it with your team by following the steps in the third section.