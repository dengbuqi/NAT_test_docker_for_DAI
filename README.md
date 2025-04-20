Here's an updated version of the README that includes the network and container details you requested:

---

### **Network Isolation and NAT Test Environment for Decentralized AI Programming**

This repository sets up a simulated environment using Docker containers to test network isolation and NAT configurations. It is designed as a testbed for decentralized AI programming, where different containers represent local networks, NAT routers, and public services. The goal is to validate network connectivity, isolation, and routing rules within the context of a decentralized setup.

The network setup consists of the following components:

```
+-------------------+       +-------------------+       +-------------------+
|   local_net1      |       |   local_net2      |       |   local_net3      |
|  (192.168.1.0/24) |       |  (192.168.2.0/24) |       |  (192.168.3.0/24) |
|                   |       |                   |       |                   |
|  P1_1, P1_2, P1_3 |       |  P2_1, P2_2, P2_3 |       |  P3_1, P3_2, P3_3 |
|        |          |       |        |          |       |        |          |
|        R1 (NAT)   |       |        R2 (NAT)   |       |        R3 (NAT)   |
+--------|----------+       +--------|----------+       +--------|----------+
         |                           |                           |
         +---------------------------+---------------------------+
                                     |
                           +---------|---------+
                           |     public_net    |
                           |   (10.0.0.0/24)  |
                           |                  |
                           |   P1, P2, P3     |
                           +-------------------+
```

#### **Network Setup:**

- **local_net1**: Subnet `192.168.1.0/24`
- **local_net2**: Subnet `192.168.2.0/24`
- **local_net3**: Subnet `192.168.3.0/24`
- **public_net**: Subnet `10.0.0.0/24`

#### **Containers:**

- **P1, P2, P3**: Public network services with IPs `10.0.0.21`, `10.0.0.22`, and `10.0.0.23`, respectively.
- **P1_1, P1_2, P1_3, ...**: Clients in `local_net1`, `local_net2`, and `local_net3` (e.g., `P1_1` is in `local_net1`, `P2_1` is in `local_net2`, etc.).
- **R1, R2, R3**: NAT routers bridging the local networks with the public network. They allow clients in local networks to access the public network while maintaining isolation between different subnets.

#### **Key Features:**

1. **NAT and Routing**:
   - Each NAT router (`R1`, `R2`, `R3`) connects its local subnet to the public network (`public_net`).
   - Containers in each local subnet can access the public network but are isolated from each other.
   - The script ensures that default routes are configured correctly for clients to route traffic through their respective NAT routers.

2. **Network Isolation**:
   - Clients in different local networks (`local_net1`, `local_net2`, `local_net3`) are isolated from each other, ensuring network boundaries.
   - The containers can test both successful and failed cross-subnet communications.

#### **How to Use:**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/network-isolation-nat-test.git
   cd network-isolation-nat-test
   ```

2. **Build and start the containers**:
   ```bash
   docker-compose up -d
   ```

3. **Initialize the network**:
   Run the `init_network.sh` script to configure NAT and set up default routes for the containers after all containers up:
   ```bash
   bash init_network.sh
   ```

4. **Run the Ping Test Script**:
   The `container_ping_test.sh` script will check connectivity and isolation between the containers:
   ```bash
   ./container_ping_test.sh
   ```

#### **Example Output**:

```
----- P1_1 Testing -----
P1_1 → 10.0.0.21 : ✅ Reachable
P1_1 → 10.0.0.22 : ✅ Reachable
P1_1 → 10.0.0.23 : ✅ Reachable
P1_1 → NAT Router (192.168.1.254): ✅ Reachable
P1_1 → P2_1 (192.168.2.11) [Isolation Test]: ✅ Isolated
P1_1 → P3_1 (192.168.3.11) [Isolation Test]: ✅ Isolated
```

This test ensures that:
- Clients can reach their respective NAT routers.
- Clients in different networks are isolated from each other.

#### **License**:

MIT License - see the [LICENSE](LICENSE) file for details.

---

This update ensures the key network and container details are properly highlighted in the README. Let me know if you'd like to adjust any further details or add more explanations!