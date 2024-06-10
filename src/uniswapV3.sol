// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import {ISwapRouter} from "src/interface/ISwapRouter.sol";
import {SafeTransferLib} from "src/safeLib/safeTransferLib.sol";
import {ERC20} from "src/token/ERC20.sol";  
   contract uniSwapV3  {

 using SafeTransferLib for ERC20;
 ISwapRouter private immutable swapRouter;
  constructor(address routerAddress) {
        swapRouter = ISwapRouter(routerAddress);

    }


    function swapExactIn(
        address baseToken,
        bytes memory data,
        uint256 amountIn,
        uint256 amountOutMinimum,
        address recipient
    ) external returns (uint256 amountOut) {
        // Transfer tokens from the user to this contract
        ERC20(baseToken).safeTransferFrom(msg.sender, address(this), amountIn);

        // Approve the router to spend the tokens
        ERC20(baseToken).approve(address(swapRouter), amountIn);

        // Call the exactInput function on the swapRouter
        amountOut = swapRouter.exactInput(
            ISwapRouter.ExactInputParams(data, recipient, block.timestamp, amountIn, amountOutMinimum)
        );
    }


 function exactInputSingle(
        address tokenIn,
        address tokenOut,
        uint24 fee,
        uint256 amountIn,
        uint256 amountOutMinimum,
        address recipient,
        uint160 sqrtPriceLimitX96
    ) external returns (uint256 amountOut) {
        // Transfer tokens from the user to this contract
        ERC20(tokenIn).safeTransferFrom(msg.sender, address(this), amountIn);

        // Approve the router to spend the tokens
        ERC20(tokenIn).approve(address(swapRouter), amountIn);

        // Call the exactInputSingle function on the swapRouter
        amountOut = swapRouter.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: fee,
                recipient: recipient,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: sqrtPriceLimitX96
            })
        );
    }
}


   
   
 