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