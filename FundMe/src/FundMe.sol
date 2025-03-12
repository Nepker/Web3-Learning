// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using   PriceConverter for uint256;

    uint256 public minimunUsd = 5e18;

    address[] public funders;
    address public owner;

    mapping(address funders => uint256 amountFunded) public addressToAmountFunded;

    constructor() {
        owner = msg.sender;
    }
    function fund() public payable {
        require(msg.value.getConversionRate() >= minimunUsd, "Not enough funds");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    } 

    function withdraw() public  onlyOwner{
        require(msg.sender == owner, "You're not the owner!");
        // address payable recipient = payable(msg.sender);
        // uint256 amount = addressToAmountFunded[msg.sender];
        // require(amount > 0, "No funds to be withdrawn");

        // bool success =  recipient.send(amount);

        // require(success, "Withdrawal failed!");

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // funders = new address[](0);
        // payable (msg.sender).transfer(addrcess(this).balance);

        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "send failed");

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
        
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "sender is not owner");
        _;
    }
    recieve() public {
        fund();
    }

    fallback() public {
        fund();
    }
}
