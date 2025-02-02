// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @custom:storage-location erc7201:assetify.globalstate
library Schema {
    struct GlobalState {
        mapping(uint256 => LoanProject) projects;
        mapping(address => Investor) investors;
        mapping(address => Borrower) borrowers;
        address arcsTokenAddress;
        uint256 nextProjectID;
        bool initialized;
    }

    enum LoanStatus { Pending, Funded, Active, Repaid, Defaulted }

    struct LoanProject {
        uint256 projectID;
        uint256 targetAmount;
        uint256 interestRate;
        uint256 loanTerm;
        uint256 minimumInvestment;
        uint256 totalInvested;
        address borrower;
        LoanStatus status;
    }

    struct Investor {
        uint256 totalInvested;
        uint256 claimableRewards;
        mapping(uint256 => uint256) investments; // projectID → 投資額
    }

    struct Borrower {
        uint256 totalBorrowed;
        uint256 totalRepaid;
        uint256 activeLoans;
    }
}
