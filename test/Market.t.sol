// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import "forge-std/Test.sol";
import "../src/bundleA/functions/Market.sol";

contract MarketTest is Test {
    Market market;

    function setUp() public {
        market = new Market();
    }

    function testPlaceOrder() public {
        market.placeOrder(1, 10 ether, 1 ether);
    }
}
