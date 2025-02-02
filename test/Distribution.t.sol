// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import "forge-std/Test.sol";
import "../src/bundleA/functions/Distribution.sol";

contract DistributionTest is Test {
    Distribution distribution;

    function setUp() public {
        distribution = new Distribution();
    }

    function testRepayLoan() public {
        distribution.repayLoan(1, 100 ether);
    }

    function testDistributeInterest() public {
        distribution.distributeInterest(1);
    }

    function testHandleDefault() public {
        distribution.handleDefault(1);
    }
}
