// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IRECFractions} from "./IRECFractions.sol";

contract IRECCertificate is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable
{
    /**
     * Used to track the token/cert id.
     */
    uint256 public nextCertificateId;

    mapping(uint256 => address) private fractionErc20Token;

    // Event to emit certificate details when minted
    event CertificateMinted(uint256 tokenId, string uri);
    event CertificateFractionalized(address erc20Address, uint256 tokenId);

    constructor(
        address initialOwner
    ) ERC721("I-REC Certificate", "I-REC") Ownable(initialOwner) {}

    /**
     * Mints new nfts given owner, certificate details, uri.
     * @param owner the owner of the nft.
     * @param uri the certificate document/image uri.
     * @return the nft id/certificate id.
     */
    function safeMint(
        address owner,
        string memory uri
    ) public onlyOwner returns (uint256) {
        uint256 tokenId = nextCertificateId++;
        _safeMint(owner, tokenId);
        _setTokenURI(tokenId, uri);
        emit CertificateMinted(tokenId, uri);
        return tokenId;
    }

    /**
     * Fractionalizes the certificate to an ERC20 token with 1000 units.
     * @param _certificateId the certificate to fractionalize.
     * @return erc20 contract address.
     */
    function fractionalize(uint256 _certificateId) public returns (address) {
        require(_exists(_certificateId), "Invalid certificate id");
        require(
            fractionErc20Token[_certificateId] == address(0),
            "Ertificate already fractionalized!!"
        );
        IRECFractions newContract = new IRECFractions(
            msg.sender,
            address(this),
            _certificateId
        );
        address deployedAddress = address(newContract);
        fractionErc20Token[_certificateId] = deployedAddress;
        emit CertificateFractionalized(deployedAddress, _certificateId);
        return deployedAddress;
    }

    /**
     * Get the address of the fractional erc20 token.
     * @param _certificateId the certificate id.
     * @return the erc20 token address.
     */
    function getFractionalERc20(
        uint256 _certificateId
    ) public view returns (address) {
        require(
            _fractionalized(_certificateId),
            "Certificate not fractionalized"
        );
        return fractionErc20Token[_certificateId];
    }

    /**
     * @dev Returns whether `tokenId` exists.
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     * If `tokenId` is not minted, this function will return false.
     */
    function _exists(
        uint256 _certificateId
    ) internal view virtual returns (bool) {
        return _ownerOf(_certificateId) != address(0);
    }

    /**
     * @dev Returns whether `tokenId` exists.
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     * If `tokenId` is not minted, this function will return false.
     */
    function _fractionalized(
        uint256 _certificateId
    ) internal view virtual returns (bool) {
        return fractionErc20Token[_certificateId] != address(0);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
