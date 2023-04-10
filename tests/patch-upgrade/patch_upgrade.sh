#!/bin/bash
# Test a patch upgrade
# 1. Set up a two-validator network chain.
# 2. Run happy path tests
# 3. Upgrade one validator to the latest build snapshot
# 4. Check for AppHash errors
# 5. Run happy path tests
# 6. Check for AppHash errors

# export START_VERSION=$1
# export TARGET_BRANCH=$2
# export PATH=$PATH:$HOME/go/bin

# export HOME_1=~/.val1
# export CONSUMER_HOME_1=~/.con1
# export MNEMONIC_1="abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon art"
# export WALLET_1=cosmos1r5v5srda7xfth3hn2s26txvrcrntldjumt8mhl
# export VALOPER_1=cosmosvaloper1r5v5srda7xfth3hn2s26txvrcrntldju7lnwmv
# export MONIKER_1=val1
# export SERVICE_1=val1.service
# export VAL1_RPC_PORT="27001"
# export CONSUMER_SERVICE_1=con1.service
# export CON1_RPC_PORT="27101"
# export HOME_2=~/.val2
# export CONSUMER_HOME_2=~/.con2
# export MNEMONIC_2="abandon cabbage abandon cabbage abandon cabbage abandon cabbage abandon cabbage abandon cabbage abandon cabbage abandon cabbage abandon cabbage abandon cabbage abandon cabbage abandon garage"
# export WALLET_2=cosmos1ay4dpm0kjmvtpug28vgw5w32yyjxa5sp97pjqq
# export MONIKER_2=val2
# export SERVICE_2=val2.service
# export VAL2_RPC_PORT="27002"
# export CONSUMER_SERVICE_2=con2.service
# export CON2_RPC_PORT="27102"

# export DENOM=uatom
# export CONSUMER_DENOM=ucon
# export VAL_FUNDS="12000000000"
# export  VAL_STAKE="1000000000"
# export VAL_STAKE_STEP="1000000"

# export CHAIN_BINARY_URL=https://github.com/cosmos/gaia/releases/download/$START_VERSION/gaiad-$START_VERSION-linux-amd64
# export CONSUMER_CHAIN_BINARY_URL=https://github.com/hyphacoop/cosmos-builds/releases/download/ics-linux-release/interchain-security-cd-linux

# export UPGRADE_BINARY_URL=https://github.com/hyphacoop/cosmos-builds/releases/download/gaiad-linux-$TARGET_BRANCH/gaiad-linux
# export CHAIN_BINARY=gaiad
# export CONSUMER_CHAIN_BINARY=consumerd
# export CHAIN_ID=testnet
# export CONSUMER_CHAIN_ID=consumer

# systemctl disable hermes.service --now

# source ./test_blocks.sh
# source ./test_signatures.sh
# source ./test_tx_fresh.sh
# source ./test_vsc.sh
# source ./test_consumer_removed.sh

# # ********************************
# # 1. Set up a two-validator chain
# # ********************************

# ./start_chain.sh

# # Verify validators are producing blocks and all validators are signing
# check_blocks $VAL1_RPC_PORT
# check_signatures $VAL1_RPC_PORT 2

# # ********************************
# # 2. Run happy path tests
# # ********************************

# # Transaction tests
# check_bank_send
# check_staking_delegate
# check_distribution_rewards
# check_staking_unbond

# # Interchain Security tests
# ./init_consumer.sh
# ./launch_consumer.sh 1

# # Verify validators are producing blocks and all validators are siagning in the consumer chain
# check_blocks $CON1_RPC_PORT
# check_signatures $CON1_RPC_PORT 2

# # Install hermes and set up connections and channels
# ./setup_relayer.sh 07-tendermint-0

# # Verify validator set change
# check_power_change

# # Remove the consumer chain
# ./stop_consumer.sh 2

# # Verify no consumer chains are running
# check_no_consumer_chains

# # Verify validators are producing blocks in the provider chain
# check_blocks $VAL1_RPC_PORT
# check_signatures $VAL1_RPC_PORT 2

# # ********************************
# # 3. Upgrade a validator
# # ********************************

# ./upgrade_vals.sh

# # ********************************
# # 4. Check for AppHash errors
# # ********************************

# # Verify validators are producing blocks in the provider chain
# check_blocks $VAL1_RPC_PORT
# check_signatures $VAL1_RPC_PORT 2

# # ********************************
# # 5. Happy path tests
# # ********************************

# # Interchain Security tests
# export CONSUMER_CHAIN_ID=consumer2
# ./init_consumer.sh
# ./launch_consumer.sh 3

# # Verify validators are producing blocks in the consumer chain
# check_blocks $CON1_RPC_PORT
# check_signatures $CON1_RPC_PORT 2

# # Install hermes and set up connections and channels
# ./setup_relayer.sh 07-tendermint-1

# # Delegate additional stake to val 1
# check_power_change

# # Remove the consumer chain
# ./stop_consumer.sh 4

# # Verify no consumer chains are running
# check_no_consumer_chains

# # ********************************
# # 6. Check for AppHash errors
# # ********************************

# # Verify validators are producing blocks in the provider chain
# check_blocks $VAL1_RPC_PORT
# check_signatures $VAL1_RPC_PORT 2
