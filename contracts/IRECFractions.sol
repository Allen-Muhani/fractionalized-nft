// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract IRECFractions is ERC20, ERC20Burnable, Ownable {
    address certificateAddress;
    uint256 certificateId;

    event Buy();
    event Sell();
    event Mint();

    constructor(
        address initialOwner,
        address _certificateAddress,
        uint256 _certificateId
    ) ERC20("I-REC Fractions", "I-RECFraction") Ownable(initialOwner) {
        certificateAddress = _certificateAddress;
        certificateId = _certificateId;
    }

    function mintTo(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function buy() public {}

    function sell() public {}
}
