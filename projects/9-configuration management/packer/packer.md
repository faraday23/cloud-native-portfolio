<h2>Situation:</h2>
<p>During my time at ABC Inc, I was given the responsibility to manage the infrastructure for multiple legacy .NET applications. We hosted these applications on Windows Server instances, and consistency in creating and provisioning these instances was critical to ensuring the applications functioned as expected.</p>

<h2>Task:</h2>
<p>My task was to automate the process of creating and provisioning Windows Server instances while ensuring that the servers were set up in a consistent manner and properly configured to support our legacy .NET applications.</p>

<h2>Action:</h2>
<p>I utilized Packer, a tool from HashiCorp, to create identical machine images for multiple platforms from a single source configuration. I created a Packer template specifying all necessary provisioning details for Windows Server instances, including software updates, system settings, and .NET framework versions and dependencies needed to support our legacy .NET applications.</p>

<p>To automate this process and ensure new Windows Server images were created every time changes were made to the Packer template or our .NET application dependencies, I set up a GitHub Actions workflow. This workflow was triggered whenever changes were pushed to our repository, leading to the creation of a new machine image via Packer.</p>

<h2>Issue/Problem:</h2>
<p>One challenge we faced was ensuring secure handling and use of sensitive data such as admin credentials and API keys during the provisioning process. We wanted to avoid hardcoding these into our GitHub repository or Packer template.</p>

<h2>Resolution:</h2>
<p>To solve this, I utilized GitHub Secrets to securely store sensitive data. These secrets were then accessed by our GitHub Actions workflow during runtime, ensuring a secure provisioning process without exposing sensitive information.</p>

<h2>Result:</h2>
<p>As a result, we were able to maintain consistency across our Windows Server instances and ensure they were always properly configured to support our legacy .NET applications. The automated process reduced human error, improved our deployment speed, and allowed us to quickly react to changes in our applications' dependencies. The security of sensitive data was also maintained, increasing the confidence and trust in our infrastructure management process. This infrastructure automation played a vital role in improving the stability of our .NET applications, enhancing overall system reliability.</p>
