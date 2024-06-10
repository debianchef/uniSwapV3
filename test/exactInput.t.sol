// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Test.sol";
import {uniSwapV3} from "src/uniswapV3.sol";
import "src/interface/IPool.sol";
import {ISwapRouter} from "src/interface/ISwapRouter.sol";
import {ERC20} from "src/token/ERC20.sol";

contract TestExactInput is Test {
    uniSwapV3 router;
    IPool pool;
    address weth;
    address usdc;
    bytes path;
    address alice;

    function setUp() public {
        uint256 forkId = vm.createFork(vm.envString("ETH_RPC_URL"), 16454867);
        vm.selectFork(forkId);

        router = new uniSwapV3(0xE592427A0AEce92De3Edee1F18E0157C05861564);
        pool = IPool(0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640);

        weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

        path = abi.encodePacked(weth, uint24(500), usdc);

        alice = address(this);
        vm.label(alice, "Alice");
    }

    function testExactInput() public {
        uint256 amountIn = 100 ether;

        // Deal WETH to Alice
        deal(weth, alice, amountIn);
        emit log_named_uint("Initial WETH balance of Alice", ERC20(weth).balanceOf(alice));

        // Approve the router to spend WETH
        ERC20(weth).approve(address(router), amountIn);

        // Alice sells 100 WETH to buy USDC. They have a limit price set.
        ISwapRouter.ExactInputParams memory params = ISwapRouter.ExactInputParams({
            path: path,
            recipient: alice,
            deadline: block.timestamp + 4,
            amountIn: amountIn,
            amountOutMinimum: 0
        });

        // Check initial balances
        uint256 initialAliceUsdcBalance = ERC20(usdc).balanceOf(alice);
        emit log_named_uint("Initial USDC balance of Alice", initialAliceUsdcBalance);

        // Perform the swap
        router.swapExactIn(weth, params.path, params.amountIn, params.amountOutMinimum, params.recipient);

        // Check final balances
        uint256 finalAliceUsdcBalance = ERC20(usdc).balanceOf(alice);
        emit log_named_uint("Final USDC balance of Alice", finalAliceUsdcBalance);

        uint256 finalAliceWethBalance = ERC20(weth).balanceOf(alice);
        emit log_named_uint("Final WETH balance of Alice after Swap", finalAliceWethBalance);

        // Assertions
        assertGt(finalAliceUsdcBalance, initialAliceUsdcBalance);
        assertEq(finalAliceWethBalance, 0, "Alice should have no WETH left");
    }
}
