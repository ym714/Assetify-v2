// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import "forge-std/Test.sol";
import "../src/bundleA/functions/LoanFactory.sol";

contract LoanFactoryTest is Test {
    LoanFactory factory;

    function setUp() public {
        factory = new LoanFactory();
    }

    function testCreateProject() public {
        factory.createProject(1000 ether, 5, 365 days, 100 ether);
    }
}
