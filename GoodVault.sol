// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GoodVault {
    mapping(address => uint) public balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        // Sửa tx.origin thành msg.sender
        balances[msg.sender] += msg.value; 
    }

    function withdraw() public {
        uint amount = balances[msg.sender];
        require(amount > 0, "No funds");

        // Sửa lỗi Reentrancy: Áp dụng CEI pattern (Cập nhật state TRƯỚC khi call)
        balances[msg.sender] = 0; 

        // Sửa lỗi Unchecked return value
        (bool success, ) = msg.sender.call{value: amount}(""); 
        require(success, "Transfer failed");
    }

    // Đã xóa hàm suicide() nguy hiểm

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
