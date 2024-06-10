This repository contains a smart contract implementation for performing swaps using Uniswap V3, including functions for exactInput and exactInputSingle.




#### Clone the repository:
```sh

git clone https://github.com/your-repository-url.git
cd your-repository-name
```

#### Run the tests:

```sh
forge test
```


#### Contract Details

The `uniSwapV3` contract includes two main functions:

***swapExactIn***:

```solidity
function swapExactIn(
    address baseToken,
    bytes memory data,
    uint256 amountIn,
    uint256 amountOutMinimum,
    address recipient
) external returns (uint256 amountOut);
```

***exactInputSingle***:

```solidity

function exactInputSingle(
    address tokenIn,
    address tokenOut,
    uint24 fee,
    uint256 amountIn,
    uint256 amountOutMinimum,
    address recipient,
    uint160 sqrtPriceLimitX96
) external returns (uint256 amountOut);
```


#### Common Issues
`Unknown selector for VmCalls`: If you encounter errors like unknown `selector  for VmCalls`, it may be due to an outdated version of Foundry. Ensure you have the latest version by running:



```sh
foundryup
forge clean
```