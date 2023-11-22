#!/bin/bash
network=$1

while true; do
    if [[ $network == "mainnet" ]]; then
        result1=$(curl --silent https://api.avax.network/ext/bc/C/rpc -X POST -H "Content-Type: application/json" --data '{"method":"eth_blockNumber","params":[],"id":1,"jsonrpc":"2.0"}' | jq -r .result)
    elif [[ $network == "testnet" ]]; then
        result1=$(curl --silent https://api.avax-test.network/ext/bc/C/rpc -X POST -H "Content-Type: application/json" --data '{"method":"eth_blockNumber","params":[],"id":1,"jsonrpc":"2.0"}' | jq -r .result)
    else
        exit 1
    fi
    
    result2=$(curl --silent https://zeeve-avalanche-mainnet-1008.zeeve.net/V1kj3ko42Gr8ULOK3DzCt/rpc -X POST -H "Content-Type: application/json" --data '{"method":"eth_blockNumber","params":[],"id":1,"jsonrpc":"2.0"}' | jq -r .result)
    
    decimal1=$(perl -le 'print hex("'$result1'");')
    decimal2=$(perl -le 'print hex("'$result2'");')

    if [ $decimal2 -lt $decimal1 ]; then
        echo "Chain Highest block: $decimal1"
        echo "Highest block of our node: $decimal2"
    else
        echo "Chain Highest block: $decimal1"
        echo "Highest block of our node: $decimal2"
        echo "Avax is synced."
        break
    fi

    sleep 300  # Wait for 5 minutes (300 seconds)
done