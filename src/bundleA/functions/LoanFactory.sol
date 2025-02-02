// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../storage/Schema.sol";
import "../storage/Storage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LoanFactory {
    event ProjectCreated(uint256 indexed projectID, address indexed borrower, uint256 targetAmount);
    event Invested(uint256 indexed projectID, address indexed investor, uint256 amount);

    function createProject(
        uint256 targetAmount,
        uint256 interestRate,
        uint256 loanTerm,
        uint256 minimumInvestment
    ) external {
        Schema.GlobalState storage $s = Storage.state();
        uint256 projectID = $s.nextProjectID++;

        $s.projects[projectID] = Schema.LoanProject({
            projectID: projectID,
            targetAmount: targetAmount,
            interestRate: interestRate,
            loanTerm: loanTerm,
            minimumInvestment: minimumInvestment,
            totalInvested: 0,
            borrower: msg.sender,
            status: Schema.LoanStatus.Pending
        });

        emit ProjectCreated(projectID, msg.sender, targetAmount);
    }

    function invest(uint256 projectID, uint256 amount) external {
        Schema.GlobalState storage $s = Storage.state();
        Schema.LoanProject storage project = $s.projects[projectID];

        require(project.status == Schema.LoanStatus.Pending, "Project not open for funding");
        require(amount >= project.minimumInvestment, "Investment below minimum");

        IERC20 arcsToken = IERC20($s.arcsTokenAddress);
        require(arcsToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        project.totalInvested += amount;
        $s.investors[msg.sender].totalInvested += amount;
        $s.investors[msg.sender].investments[projectID] += amount;

        if (project.totalInvested >= project.targetAmount) {
            project.status = Schema.LoanStatus.Funded;
        }

        emit Invested(projectID, msg.sender, amount);
    }
}
