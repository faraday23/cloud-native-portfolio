<!DOCTYPE html>
<html>

<head>
  <title>Load Testing Task</title>
</head>

<body>
  <h1>Situation</h1>
  <p>I was working as a DevOps engineer in a company that developed a new web application. The management wanted to ensure that the application could handle heavy loads during peak usage hours.</p>

  <h1>Task</h1>
  <p>My task was to simulate realistic user traffic, monitor performance, and identify any potential issues that could affect the performance and stability of the application during high traffic periods. I decided to use k6 for load testing, InfluxDB for storing the metrics, and Grafana for visualizing the data.</p>

  <h1>Action</h1>
  <ol>
    <li>First, I created a k6 script in JavaScript that simulated realistic user behavior, such as logging in, browsing pages, and making purchases.</li>
    <li>Then, I set up k6 to send the performance metrics to InfluxDB. This involved configuring k6 to use the InfluxDB output and specifying the URL of the InfluxDB instance.</li>
    <li>Once this was set up, I ran the load test using k6. This involved executing the script with a certain number of virtual users for a certain duration. I started with a moderate load and gradually increased the number of virtual users to simulate a traffic spike.</li>
    <li>While the load test was running, I used Grafana to visualize the performance metrics stored in InfluxDB. I created a dashboard with various charts showing metrics like request rates, response times, and error rates.</li>
    <li>I monitored these charts during the load test and looked for any signs of performance degradation, such as increasing response times or error rates.</li>
  </ol>

  <h1>Issue/Problem</h1>
  <p>During the load test, I noticed that the response times were increasing significantly when the number of virtual users reached a certain threshold. This indicated that the application was struggling to handle the load and that users might experience slow page loads during peak usage hours.</p>

  <h1>Resolution</h1>
  <p>To address this issue:</p>
  <ol>
    <li>I analyzed the performance metrics and identified that the database was the bottleneck. It was taking a long time to respond to queries when the load was high.</li>
    <li>To address this issue, I worked with the development team to optimize the database queries and indexes. We also scaled up the database server to handle more connections and queries.</li>
    <li>After these changes, I ran the load test again. This time, the response times remained stable even when the number of virtual users was high. This confirmed that the changes we made had improved the performance of the application.</li>
  </ol>

  <h1>Result</h1>
  <p>As a result, we were able to ensure that the application could handle high traffic loads without degrading performance. We were able to identify and fix a performance bottleneck before the application was launched. This prevented potential user dissatisfaction and negative impact on the business. I received positive feedback from the management for effectively handling this task.</p>
</body>

</html>


```js
// Import k6 modules
import http from 'k6/http';
import { check, sleep } from 'k6';

// Define user scenarios
export let options = {
  scenarios: {
    login: {
      executor: 'constant-vus',
      vus: 10,
      duration: '5m',
      tags: { type: 'login' },
    },
    browse: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '5m', target: 50 },
        { duration: '10m', target: 100 },
        { duration: '5m', target: 0 },
      ],
      tags: { type: 'browse' },
    },
    purchase: {
      executor: 'per-vu-iterations',
      vus: 20,
      iterations: 10,
      maxDuration: '15m',
      tags: { type: 'purchase' },
    },
  },
};

// Define base URL and endpoints
const BASE_URL = 'https://example.com';
const LOGIN_URL = `${BASE_URL}/login`;
const BROWSE_URL = `${BASE_URL}/browse`;
const PURCHASE_URL = `${BASE_URL}/purchase`;

// Define user credentials
const USERNAME = 'test@example.com';
const PASSWORD = 'password';

// Define think time
const THINK_TIME = 3;

// Define helper function to generate random number
function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min);
}

// Define login scenario
export function login() {
  // Make a POST request to login endpoint with username and password
  let loginRes = http.post(LOGIN_URL, {
    username: USERNAME,
    password: PASSWORD,
  });

  // Check if the login was successful and the response code was 200
  check(loginRes, {
    'login was successful': (r) => r.status === 200,
  });

  // Sleep for some time to simulate user think time
  sleep(THINK_TIME);
}

// Define browse scenario
export function browse() {
  // Make a GET request to browse endpoint with a random category
  let categories = ['books', 'electronics', 'clothing', 'toys'];
  let category = categories[randomInt(0, categories.length - 1)];
  let browseRes = http.get(`${BROWSE_URL}?category=${category}`);

  // Check if the browse was successful and the response code was 200
  check(browseRes, {
    'browse was successful': (r) => r.status === 200,
  });

  // Sleep for some time to simulate user think time
  sleep(THINK_TIME);
}

// Define purchase scenario
export function purchase() {
  // Make a POST request to purchase endpoint with a random product id and quantity
  let productIds = [1, 2, 3, 4, 5];
  let productId = productIds[randomInt(0, productIds.length - 1)];
  let quantity = randomInt(1, 5);
  let purchaseRes = http.post(PURCHASE_URL, {
    productId: productId,
    quantity: quantity,
  });

  // Check if the purchase was successful and the response code was 200
  check(purchaseRes, {
    'purchase was successful': (r) => r.status === 200,
  });

  // Sleep for some time to simulate user think time
  sleep(THINK_TIME);
}
```