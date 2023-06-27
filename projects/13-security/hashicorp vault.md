<h2>Situation:</h2>
<p>While working at XYZ Tech as a DevOps Engineer, we used Kubernetes hosted on Azure, referred to as AKS, for managing and deploying our microservices-based applications. To store, manage, and tightly control access to tokens, passwords, certificates, API keys, and other secrets, we used HashiCorp Vault.</p>

<h2>Task:</h2>
<p>My task was to introduce an automated and secure way for our applications, specifically the Kubernetes pods, to access the secrets stored in the HashiCorp Vault without hardcoding them into the application or Kubernetes deployment configuration files.</p>

<h2>Action:</h2>
<p>To accomplish this, I leveraged the HashiCorp Vault's Kubernetes Secrets Injector, a sidecar injector in Kubernetes, that uses the Kubernetes Mutating Admission Webhook to intercept and modify pod specifications at runtime to inject secrets into the pod.</p>

<h2>Issue/Problem:</h2>
<p>During the initial phase, we faced an issue. Some of the pods failed to initialize properly after injecting the secrets. On investigation, it turned out that the applications inside the pods were trying to start before the Vault sidecar container could fetch and write the secrets, causing them to fail because they couldn't access the necessary secrets at startup.</p>

<h2>Resolution:</h2>
<p>To resolve this, I implemented init containers in the Kubernetes pod configuration to ensure that the Vault sidecar container runs and fetches the secrets before the application containers start. In addition, I configured readiness probes to ensure that our applications would not start until the Vault has successfully injected the necessary secrets.</p>

<h2>Result:</h2>
<p>As a result of these changes, we were able to securely and dynamically inject secrets into the pods. Applications were no longer failing at startup due to missing secrets, which improved the stability of our microservices. This method also allowed us to achieve a higher level of security by eliminating the need to hardcode secrets in our applications or Kubernetes configurations. This successful implementation resulted in a more secure and reliable system, strengthening the trust of our stakeholders in our infrastructure.</p>
