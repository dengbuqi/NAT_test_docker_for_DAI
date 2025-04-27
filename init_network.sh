set -e

echo "🚀 Setting up NAT routers and client routes..."

echo "Run R1 NAT"
docker exec R1 sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
docker exec R1 iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth1 -j MASQUERADE

echo "Run R2 NAT"
docker exec R2 sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
docker exec R2 iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -o eth1 -j MASQUERADE

echo "Run R3 NAT"
docker exec R3 sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
docker exec R3 iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o eth1 -j MASQUERADE

echo "Config p1_x default route → R1"
docker exec P1_1 ip route del default || true
docker exec P1_1 ip route add default via 192.168.1.254
docker exec P1_2 ip route del default || true
docker exec P1_2 ip route add default via 192.168.1.254
docker exec P1_3 ip route del default || true
docker exec P1_3 ip route add default via 192.168.1.254

echo "Config p2_x default route → R2"
docker exec P2_1 ip route del default || true
docker exec P2_1 ip route add default via 192.168.2.254
docker exec P2_2 ip route del default || true
docker exec P2_2 ip route add default via 192.168.2.254
docker exec P2_3 ip route del default || true
docker exec P2_3 ip route add default via 192.168.2.254

echo "Config p3_x default route → R3"
docker exec P3_1 ip route del default || true
docker exec P3_1 ip route add default via 192.168.3.254
docker exec P3_2 ip route del default || true
docker exec P3_2 ip route add default via 192.168.3.254
docker exec P3_3 ip route del default || true
docker exec P3_3 ip route add default via 192.168.3.254

echo "✅ NAT and Default Route has been configured."