#!/bin/bash

containers=(
  P1_1 P1_2 P1_3
  P2_1 P2_2 P2_3
  P3_1 P3_2 P3_3
)

# Containers mapped to subnets
declare -A container_subnet=(
  [P1_1]="192.168.1"
  [P1_2]="192.168.1"
  [P1_3]="192.168.1"
  [P2_1]="192.168.2"
  [P2_2]="192.168.2"
  [P2_3]="192.168.2"
  [P3_1]="192.168.3"
  [P3_2]="192.168.3"
  [P3_3]="192.168.3"
)

# Public services (should be reachable)
public_targets=(
  10.0.0.21  # P1
  10.0.0.22  # P2
  10.0.0.23  # P3
)

# NAT routers
declare -A router_ip=(
  [P1_1]="192.168.1.254"
  [P1_2]="192.168.1.254"
  [P1_3]="192.168.1.254"
  [P2_1]="192.168.2.254"
  [P2_2]="192.168.2.254"
  [P2_3]="192.168.2.254"
  [P3_1]="192.168.3.254"
  [P3_2]="192.168.3.254"
  [P3_3]="192.168.3.254"
)

echo "========== Start Ping Test =========="

for src in "${containers[@]}"; do
  echo "----- $src (${container_subnet[$src]}) Testing -----"

  # Ping public services (should pass)
  for dst in "${public_targets[@]}"; do
    echo -n "$src → $dst : "
    docker exec $src ping -c 1 -W 1 $dst >/dev/null && echo "✅" || echo "❌"
  done

  # Ping own router (should pass)
  echo -n "$src → NAT Router (${router_ip[$src]}): "
  docker exec $src ping -c 1 -W 1 "${router_ip[$src]}" >/dev/null && echo "✅" || echo "❌"

  # Ping other subnets' clients (should fail)
  for other in "${containers[@]}"; do
    if [[ "$other" != "$src" && "${container_subnet[$other]}" != "${container_subnet[$src]}" ]]; then
      ip="${container_subnet[$other]}.${other: -1}1"  # ex: P2_2 → 192.168.2.21
      echo -n "$src → $other ($ip) [Isolation Test]: "
      docker exec $src ping -c 1 -W 1 $ip >/dev/null && echo "❌ Should be isolated" || echo "✅ (Isolated)"
    fi
  done

  echo ""
done

echo "========== Done =========="
echo "All containers have been tested."
echo "Please check the results above."
echo "If you see ❌, please check the network configuration."
echo "If you see ✅, the network is working fine."
echo "If you see no output, please check the container status."