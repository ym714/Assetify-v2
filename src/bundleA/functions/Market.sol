// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../storage/Schema.sol";
import "../storage/Storage.sol";

contract Market is Ownable {
    struct Order {
        address seller;
        uint256 amount;
        uint256 price;
        bool isActive;
    }

    mapping(uint256 => Order[]) public orderBook; // projectID → 売り注文リスト

    event OrderPlaced(uint256 indexed projectID, address indexed seller, uint256 amount, uint256 price);
    event OrderMatched(uint256 indexed projectID, address indexed buyer, address indexed seller, uint256 amount, uint256 price);

    function placeOrder(uint256 projectID, uint256 amount, uint256 price) external {
        IERC20 arcsToken = IERC20(Storage.state().arcsTokenAddress);
        require(arcsToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        orderBook[projectID].push(Order({
            seller: msg.sender,
            amount: amount,
            price: price,
            isActive: true
        }));

        emit OrderPlaced(projectID, msg.sender, amount, price);
    }

    function matchOrder(uint256 projectID, uint256 orderIndex) external payable {
        Order storage order = orderBook[projectID][orderIndex];
        require(order.isActive, "Order not active");
        require(msg.value >= order.price * order.amount, "Insufficient ETH");

        IERC20 arcsToken = IERC20(Storage.state().arcsTokenAddress);
        require(arcsToken.transfer(msg.sender, order.amount), "Token transfer failed");

        payable(order.seller).transfer(msg.value);
        order.isActive = false;

        emit OrderMatched(projectID, msg.sender, order.seller, order.amount, order.price);
    }
}
