// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";

contract Distribution {
    event Repaid(uint256 indexed projectID, address indexed borrower, uint256 amount);
    event InterestDistributed(uint256 indexed projectID, uint256 totalInterest);
    event DefaultHandled(uint256 indexed projectID);

    function repayLoan(uint256 projectID, uint256 amount) external {
        Schema.GlobalState storage $s = Storage.state();
        Schema.LoanProject storage project = $s.projects[projectID];

        require(project.status == Schema.LoanStatus.Active, "Loan is not active");
        require(amount > 0, "Repayment amount must be greater than zero");

        IERC20 arcsToken = IERC20($s.arcsTokenAddress);
        require(arcsToken.transferFrom(msg.sender, address(this), amount), "Repayment failed");

        project.totalInvested -= amount;

        if (project.totalInvested == 0) {
            project.status = Schema.LoanStatus.Repaid;
        }

        emit Repaid(projectID, msg.sender, amount);
    }

    function distributeInterest(uint256 projectID) external {
        Schema.GlobalState storage $s = Storage.state();
        Schema.LoanProject storage project = $s.projects[projectID];

        require(project.status == Schema.LoanStatus.Repaid, "Loan not fully repaid");

        uint256 totalInterest = (project.targetAmount * project.interestRate) / 100;

        for (uint256 i = 0; i < $s.nextProjectID; i++) {
            address investor = msg.sender;
            uint256 investedAmount = $s.investors[investor].investments[projectID];
            if (investedAmount > 0) {
                uint256 reward = (investedAmount * totalInterest) / project.targetAmount;
                $s.investors[investor].claimableRewards += reward;
            }
        }

        emit InterestDistributed(projectID, totalInterest);
    }

    function handleDefault(uint256 projectID) external {
        Schema.GlobalState storage $s = Storage.state();
        Schema.LoanProject storage project = $s.projects[projectID];

        require(project.status == Schema.LoanStatus.Active, "Loan must be active to handle default");

        project.status = Schema.LoanStatus.Defaulted;
        emit DefaultHandled(projectID);
    }
}
