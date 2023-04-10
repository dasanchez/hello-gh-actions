#!/bin/bash
# Test transactions with a fresh state.


check_code()
{
  txhash=$1
  code=$($CHAIN_BINARY q tx $txhash -o json | jq '.code')
  if [ $code -eq 0 ]
  then
    return 0
  else
    return 1
  fi
}

$CHAIN_BINARY q bank balances $WALLET_1 --home $HOME_1
$CHAIN_BINARY tx bank send $WALLET_1 $WALLET_2 100003000$DENOM --home $HOME_1 --from $MONIKER_1 --keyring-backend test --gas auto --fees 1000$DENOM --chain-id $CHAIN_ID -y -o json -b block
# echo "Sending funds with tx bank send..."
# TXHASH=$($CHAIN_BINARY tx bank send $WALLET_1 $WALLET_2 100003000$DENOM --home $HOME_1 --from $MONIKER_1 --keyring-backend test --fees 1000$DENOM --chain-id $CHAIN_ID -y -o json -b block | jq '.txhash' | tr -d '"')
# check_code $TXHASH
