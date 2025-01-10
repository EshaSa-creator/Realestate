// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PlatformToken is ERC20 {
    constructor(string memory name, string memory symbol, uint8 decimals) 
        ERC20(name, symbol) 
    {
        _mint(msg.sender, 1000000 * 10**decimals); // Mint 1 million tokens to deployer
    }
}