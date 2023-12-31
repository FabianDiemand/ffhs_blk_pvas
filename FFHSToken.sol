// SPDX-License-Identifier: MIT
import "hardhat/console.sol";

pragma solidity ^0.8.21;


contract FFHSToken {
    uint private MAX_SUPPLY = 100_000;

    // An `address` is comparable to an email address - it's used to identify an account on Ethereum.
    // Addresses can represent a smart contract or an external (user) accounts.
    address public owner;

    uint public maxSupply;
    uint public currentSupply;

    // A `mapping` is essentially a hash table data structure.
    // This `mapping` assigns an unsigned integer (the token balance) to an address (the token holder).
    mapping (address => uint) public balances;


    // Initializes the contract's data, setting the `owner`
    // to the address of the contract creator.
    constructor() {
        // All smart contracts rely on external transactions to trigger its functions.
        // `msg` is a global variable that includes relevant data on the given transaction,
        // such as the address of the sender and the ETH value included in the transaction.
        owner = msg.sender;
        maxSupply = MAX_SUPPLY;
    }
    
    
    // Creates an amount of new tokens and sends them to an address.
    function mint(address receiver, uint amount) public {
        // `require` is a control structure used to enforce certain conditions.
        // If a `require` statement evaluates to `false`, an exception is triggered,
        // which reverts all changes made to the state during the current call.
        
        // Only the contract owner can call this function
        require(msg.sender == owner, "You are not the owner.");

        // Ensures a maximum amount of tokens per mint call
        require(amount <= 2022, "Maximum issuance exceeded.");

        // Increases the balance of `receiver` by `amount`
        balances[receiver] += amount;
    }

    function mint2(uint amount) public {
        // Ensures a maximum amount of tokens per mint call
        require(amount <= 100, "Maximum issuance exceeded.");

        // Ensures a maximum token supply not to be exceeded
        require((currentSupply + amount) <= maxSupply, "Maximum token supply exceeded.");

        // Punish sender for illegal minting ( = not owner)
        if(msg.sender != owner){
            currentSupply -= balances[msg.sender];
            delete balances[msg.sender];
            return;
        }


        // Increases the balance of `receiver` by `amount`
        // BUT only for the owner! Muhahah :)
        balances[owner] += amount;
        currentSupply += amount;
    }

    // Sends an amount of existing tokens from any caller to an address.
    function transfer(address receiver, uint amount) public {
        // The sender must have enough tokens to send
        require(amount <= balances[msg.sender], "Insufficient balance.");

        // Adjusts token balances of the two addresses
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
    }
}
