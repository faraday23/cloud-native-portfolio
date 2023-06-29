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