**Situation**: We were working in an environment where applications were deployed on a Kubernetes cluster. These applications had redundancy and failover mechanisms built-in, and we had made assumptions on their ability to withstand failures and maintain availability. However, these assumptions were yet to be tested under controlled conditions. It was necessary to ensure that these applications could handle failures gracefully and wouldn't cause a significant outage in the production environment.

**Task**: I was tasked with creating a chaos engineering script using Python and chaoskube library. The goal was to simulate different failure scenarios like stressing CPU, creating network partitions, filling disk, stressing IO, hogging memory, and killing pods on nodes. By creating these failure scenarios, we intended to test the resilience of our applications and determine whether they could handle the failures as expected.

**Action**: I implemented a Python script using the `chaoskube` library to introduce different types of failures in our Kubernetes nodes. The script annotated each node to run different chaos scenarios, such as stressing the CPU, creating a network partition, filling up the disk, stressing the IO, hogging the memory, and killing pods. After each chaos action, the script paused for 30 seconds before moving to the next chaos scenario. Once all the scenarios were run on a node, the script cleaned up the chaos scenarios and then proceeded to the next node.

**Issue/Problem**: During the initial tests, I noticed that the chaos actions were not having the desired impact because the next action was started before the previous action had time to take effect. The 30-second pause was not sufficient for the chaos scenarios to cause a significant impact on the system.

**Resolution**: To resolve this issue, I revised the chaos engineering strategy to introduce a more extended period between each chaos action. By extending the period to a few minutes, each chaos action had enough time to have a significant impact on the system before the next action was started. Additionally, I also introduced monitoring and logging to track the impact of each chaos action on the system.

**Result**: After implementing the changes, the script was able to effectively simulate different failure scenarios on our Kubernetes nodes, and we were able to see how our applications handled these failures. This allowed us to identify weak points in our applications and infrastructure and to make necessary changes to improve their resilience. Consequently, we were able to increase the reliability and fault tolerance of our applications, making our system more robust in the face of unexpected failures.



```python
import subprocess
from chaosk8s import create_k8s_api_client
from chaosk8s.node.actions import cordon
from chaosk8s.pod.actions import terminate_pods
from chaosk8s.pod.probes import pods_in_phase
import time
from kubernetes import client, config

# Initialize the Kubernetes client
config.load_kube_config()
v1 = client.CoreV1Api()

# List of node names
nodes = ["node1", "node2"]

# Chaos function to stress CPU
def stress_cpu_on_node(node):
    print("Stressing CPU on node: ", node)
    subprocess.run(["kubectl", "annotate", "node", node, "chaos.alpha.kubernetes.io/daemonset=chaos-cpu-stress"])

# Chaos function to create network partition
def create_network_partition(node):
    print("Creating network partition on node: ", node)
    subprocess.run(["kubectl", "annotate", "node", node, "chaos.alpha.kubernetes.io/daemonset=chaos-network-partition"])

# Chaos function to fill disk
def fill_disk(node):
    print("Filling disk on node: ", node)
    subprocess.run(["kubectl", "annotate", "node", node, "chaos.alpha.kubernetes.io/daemonset=chaos-disk-fill"])

# Chaos function to stress IO
def stress_io_on_node(node):
    print("Stressing IO on node: ", node)
    subprocess.run(["kubectl", "annotate", "node", node, "chaos.alpha.kubernetes.io/daemonset=chaos-io-stress"])

# Chaos function to hog memory
def memory_hog_on_node(node):
    print("Hogging memory on node: ", node)
    subprocess.run(["kubectl", "annotate", "node", node, "chaos.alpha.kubernetes.io/daemonset=chaos-memory-hog"])

# Chaos function to kill pods
def kill_pods(node):
    print("Killing pods on node: ", node)
    subprocess.run(["kubectl", "annotate", "node", node, "chaos.alpha.kubernetes.io/daemonset=chaos-pod-kill"])

# Cleanup function to remove the chaos scenarios
def cleanup(node):
    print("Cleaning up chaos scenarios on node: ", node)
    subprocess.run(["kubectl", "annotate", "node", node, "chaos.alpha.kubernetes.io/daemonset-"])

# Run chaos scenarios on the nodes
for node in nodes:
    stress_cpu_on_node(node)
    time.sleep(30)
    create_network_partition(node)
    time.sleep(30)
    fill_disk(node)
    time.sleep(30)
    stress_io_on_node(node)
    time.sleep(30)
    memory_hog_on_node(node)
    time.sleep(30)
    kill_pods(node)
    time.sleep(30)
    cleanup(node)
    time.sleep(30)
```