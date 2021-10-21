// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {
    mapping(address => uint256) private balances;

    mapping(address => bool) public enrolled;

    address public owner = msg.sender;

    event LogEnrolled(address addr);

    event LogDepositMade(address accountAddress, uint256 amount);

    event LogWithdrawal(
        address accountAddress,
        uint256 withdrawAmount,
        uint256 newBalance
    );

    /*
    This fallback function is throwing an error so I commented it out.

    // function() external payable {
    //     revert();
    // }

    simple-bank-exercise-geoffturk on  master [!] via ⬢ v14.18.0 took 8s
    ➜ truffle test

    Compiling your contracts...
    ===========================
    > Compiling ./contracts/Migrations.sol
    > Compiling ./contracts/SimpleBank.sol

    ParserError: Expected a state variable declaration. If you intended this as a fallback function or a function to handle plain ether transactions, use the "fallback" keyword or the "receive" keyword instead.
      --> project:/contracts/SimpleBank.sol:23:33:
      |
    23 |     function() external payable {
      |                                 ^

    Compilation failed. See above.
    Truffle v5.4.15 (core: 5.4.15)
    Node v14.18.0

    simple-bank-exercise-geoffturk on  master [!] via ⬢ v14.18.0 took 5s
    ➜ truffle version
    Truffle v5.4.15 (core: 5.4.15)
    Solidity - 0.8.5 (solc-js)
    Node v14.18.0
    Web3.js v1.5.3
*/

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function enroll() public returns (bool) {
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    function deposit() public payable returns (uint256) {
        require(
            enrolled[msg.sender] == true,
            "Must be enrolled to make a deposit"
        );
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    function withdraw(uint256 withdrawAmount) public payable returns (uint256) {
        require(balances[msg.sender] >= withdrawAmount, "Not enough funds");
        payable(msg.sender).transfer(withdrawAmount);
        balances[msg.sender] -= withdrawAmount;
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return balances[msg.sender];
    }
}
