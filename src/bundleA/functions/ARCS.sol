// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ARCS is ERC20, Ownable {
    mapping(uint256 => uint256) public projectInterestRates;

    constructor() ERC20("ARCS Token", "ARCS") {}

    function issue(address to, uint256 amount, uint256 projectID, uint256 interestRate) external onlyOwner {
        _mint(to, amount);
        projectInterestRates[projectID] = interestRate;
    }

    function redeem(uint256 amount) external {
        _burn(msg.sender, amount);
        // 償還処理を追加
    }
}
