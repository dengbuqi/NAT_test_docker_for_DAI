# https://github.com/exo-explore/exo/issues/728#issuecomment-2832231515
# https://github.com/exo-explore/exo/issues/155#issuecomment-2395252547
# https://github.com/exo-explore/exo/issues/459#issuecomment-2477883414
# https://github.com/exo-explore/exo/issues/459#issuecomment-2480154956
# https://github.com/tinygrad/tinygrad/issues/5730
# docker exec P1 sh -c "HCQDEV_WAIT_TIMEOUT_MS=30000 SUPPORT_BF16=0 DEBUG_DISCOVERY=7 exo --discovery-module manual --node-id="P1" --discovery-config-path ./exo_config/config.json --chatgpt-api-port 52418 --node-port 52415 > ./exo_config/exo_P1.log 2>&1 &"
docker exec P2 sh -c "HCQDEV_WAIT_TIMEOUT_MS=30000 SUPPORT_BF16=0 DEBUG_DISCOVERY=7 exo --discovery-module manual --node-id="P2" --discovery-config-path ./exo_config/config.json --chatgpt-api-port 52418 --node-port 52415 > ./exo_config/exo_P2.log 2>&1 &"
docker exec P3 sh -c "HCQDEV_WAIT_TIMEOUT_MS=30000 SUPPORT_BF16=0 DEBUG_DISCOVERY=7 exo --discovery-module manual --node-id="P3" --discovery-config-path ./exo_config/config.json --chatgpt-api-port 52418 --node-port 52415 > ./exo_config/exo_P3.log 2>&1 &"