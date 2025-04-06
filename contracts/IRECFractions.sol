// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract IRECFractions is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    /**
     * This should be the 1 mega whatt required per certificate.
     */
    uint256 A_THOUSAND_KW_IN_WHATS = 1_000_000;
    uint256 DEFAULT_PRICE_PER_WATT = 260;

    address public usdcAddress;
    ERC20 usdc;

    address public certificateAddress;
    uint256 public certificateId;
    uint256 public priceInUsdc;

    event Buy(uint256 amount, address buyer);
    event Sell(uint256 amount, address seller);
    event PriceChange(uint256 newPrice);

    constructor(
        address initialOwner,
        address _certificateAddress,
        uint256 _certificateId
    ) ERC20("I-REC Fractions", "I-RECFraction") Ownable(initialOwner) {
        certificateAddress = _certificateAddress;
        certificateId = _certificateId;
        priceInUsdc = DEFAULT_PRICE_PER_WATT;
        _mint(address(this), A_THOUSAND_KW_IN_WHATS);
    }

    /**
     * Set token price in usdc.
     * @param priceUSDC price in usdc wei.
     */
    function setPrice(uint256 priceUSDC) public onlyOwner {
        priceInUsdc = priceUSDC;
        emit PriceChange(priceUSDC);
    }

    /**
     * Set the usdc address.
     * @param _usdcAddress the usdc token address.
     */
    function setUSDCAddress(address _usdcAddress) public onlyOwner {
        usdc = ERC20(_usdcAddress);
        usdcAddress = _usdcAddress;
    }

    /**
     * Buy tokens from this smart contract.
     * @param tokenAmount the IRECFractions to buy.
     */
    function buy(uint256 tokenAmount) public nonReentrant {
        require(tokenAmount >= 1000, "Amount must be more than 0.1 KW");
        require(
            tokenAmount <= A_THOUSAND_KW_IN_WHATS,
            "Only 1000 tokens available per fertificate"
        );

        require(
            balanceOf(address(this)) >= tokenAmount,
            "The amount requested is not available at the moment"
        );

        uint256 totalUSDC = tokenAmount * priceInUsdc;

        require(
            usdc.balanceOf(msg.sender) >= totalUSDC,
            "You do not have sufficient balance to purchase the requested tokens."
        );

        usdc.transferFrom(msg.sender, address(this), totalUSDC);
        _transfer(address(this), msg.sender, tokenAmount);
        emit Buy(tokenAmount, msg.sender);
    }

    /**
     * Sell tokens to this smart contract.
     * @param tokenAmount the IRECFractions to buy.
     */
    function sell(uint256 tokenAmount) public nonReentrant {
        require(tokenAmount >= 1000, "Amount must be more than 0.1 KW");
        uint256 totalUSDC = tokenAmount * priceInUsdc;
        require(
            usdc.balanceOf(address(this)) >= totalUSDC,
            "Not enough USDC at the moment"
        );

        require(
            balanceOf(msg.sender) >= tokenAmount,
            "Token amount exceeds your balance"
        );

        usdc.approve(address(this), totalUSDC);
        usdc.transferFrom(address(this), msg.sender, totalUSDC);

        _transfer(msg.sender, address(this), tokenAmount);
        emit Sell(tokenAmount, address(msg.sender));
    }
}
