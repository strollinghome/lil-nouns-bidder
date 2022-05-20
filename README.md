# Lil Nouns Bidder

## Install Foundry
See the [Foudry Github](https://github.com/gakonst/foundry#installation) repo for installation.

### Install libraries
```
forge install
```

### Set up remappings
```
forge remappings > remappings.txt
```


## Test
Run against a mainnet fork:
```
forge run ./src/Contract.sol -vvvv --rpc-url ${MAINNET_URL}
```
