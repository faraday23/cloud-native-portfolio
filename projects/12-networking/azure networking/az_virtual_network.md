
<h1>Situation</h1>
<p>I was a DevOps engineer working for a company that provided online services to customers. My responsibilities included deploying and managing the cloud infrastructure that supported the applications.</p>

<h1>Task</h1>
<p>I was asked to design and implement a secure and scalable network architecture for the applications using Azure services. The goal was to ensure that the network traffic between Azure resources and on-premises resources was encrypted and filtered, and that the applications were accessible from the internet with high availability and performance.</p>


1. **Azure Provider Configuration**
   
   Define the provider and version for Azure that will allow Terraform to interact with Azure's resources.
   ```hcl
   provider "azurerm" {
       features {}
       version = "=2.54.0"
   }
   ```

2. **Azure Virtual Network Creation**

   Create a resource block for the Azure virtual network and subnets.
   ```hcl
   resource "azurerm_virtual_network" "main" {
       name                = "mainNetwork"
       address_space       = ["10.0.0.0/16"]
       location            = "West US 2"
       resource_group_name = "resourceGroupName"
   }

   resource "azurerm_subnet" "subnet1" {
       name                 = "subnet1"
       resource_group_name  = "resourceGroupName"
       virtual_network_name = azurerm_virtual_network.main.name
       address_prefixes     = ["10.0.1.0/24"]
   }
   
   // Create additional subnets as needed
   ```

3. **Azure Network Security Groups Creation**

   Create NSGs and associate them with the subnets.
   ```hcl
   resource "azurerm_network_security_group" "nsg" {
       name                = "mainNSG"
       location            = "West US 2"
       resource_group_name = "resourceGroupName"

       security_rule {
           name                       = "SSH"
           priority                   = 1001
           direction                  = "Inbound"
           access                     = "Allow"
           protocol                   = "Tcp"
           source_port_range          = "*"
           destination_port_range     = "22"
           source_address_prefix      = "*"
           destination_address_prefix = "*"
       }

       // Define additional security rules as needed
   }

   resource "azurerm_subnet_network_security_group_association" "association" {
       subnet_id                 = azurerm_subnet.subnet1.id
       network_security_group_id = azurerm_network_security_group.nsg.id
   }
   ```

4. **Azure ExpressRoute Creation**

   Create an ExpressRoute circuit and peer it with the virtual network. (For simplicity, the following code only creates the ExpressRoute circuit. Peering usually requires a connection to an existing on-prem network.)
   ```hcl
   resource "azurerm_express_route_circuit" "expressroute" {
       name                  = "expressRoute1"
       resource_group_name   = "resourceGroupName"
       location              = "West US 2"
       service_provider_name = "Equinix"
       peering_location      = "Silicon Valley"
       bandwidth_in_mbps     = 50
       sku_tier              = "Standard"
       sku_family            = "MeteredData"
   }
   ```

5. **Azure Firewall Creation**

   Create a firewall and apply rules to filter traffic.
   ```hcl
   resource "azurerm_firewall" "firewall" {
       name                = "firewall1"
       location            = "West US 2"
       resource_group_name = "resourceGroupName"
       ip_configuration {
           name                 = "configuration"
           subnet_id            = azurerm_subnet.subnet1.id
           public_ip_address_id = azurerm_public_ip.public_ip.id
       }
   }

   resource "azurerm_firewall_network_rule_collection" "network_rule_collection" {
       name                = "networkRuleCollection1"
       azure_firewall_name = azurerm_firewall.firewall.name
       resource_group_name = "resourceGroupName"
       priority            = 100
       action              = "Deny"

       rule {
           name                  = "rule1"
           protocols             = ["TCP"]
           source_addresses      = ["*"]
           destination_addresses = ["*"]
           destination_ports     = ["22"]
       }

       // Define additional rules as needed
   }
   ```

6. **Azure Front Door Creation**

   Create an Azure Front Door to act as a global load balancer and WAF for your applications.
   ```hcl
   resource "azurerm_frontdoor" "frontdoor" {
       name                                         = "frontdoor1"
       resource_group_name                          = "resourceGroupName"
       location                                     = "global"
       enforce_backend_pools_certificate_name_check = false

       routing_rule {
           name               = "routingRule1"
           accepted_protocols = ["Http", "Https"]
           patterns_to_match  = ["/*"]
           frontend_endpoints = ["frontendEndpoint1"]
           forwarding_configuration {
               forwarding_protocol = "MatchRequest"
               backend_pool_name   = "backendPool1"
           }
       }

       backend_pool_load_balancing {
           name = "loadBalancingSettings1"
       }

       backend_pool_health_probe {
           name = "healthProbeSettings1"
       }

       backend_pool {
           name = "backendPool1"
           backend {
               host_header = "example.com"
               address     = "example.com"
               http_port   = 80
               https_port  = 443
           }

           // Add additional backends as needed
       }

       frontend_endpoint {
           name      = "frontendEndpoint1"
           host_name = "example.com"
       }
   }
   ```

