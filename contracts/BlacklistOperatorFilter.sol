// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Erc721OperatorFilter/IOperatorFilter.sol";

contract BlacklistOperatorFilter is Ownable, IOperatorFilter {
    mapping(address => bool) blockedAddresses_;
    mapping(bytes32 => bool) blockedCodeHashes_;

    function mayTransfer(address operator) external view override returns (bool) {
        if (blockedAddresses_[operator]) return false;
        if (blockedCodeHashes_[operator.codehash]) return false;
        return true;
    }

    function setAddressBlocked(address a, bool blocked) external onlyOwner {
        blockedAddresses_[a] = blocked;
    }

    function setCodeHashBlocked(bytes32 codeHash, bool blocked)
        external
        onlyOwner
    {
        if (codeHash == keccak256(""))
            revert("BlacklistOperatorFilter: can't block EOAs");
        blockedCodeHashes_[codeHash] = blocked;
    }

    function isAddressBlocked(address a) external view returns (bool) {
        return blockedAddresses_[a];
    }

    function isCodeHashBlocked(bytes32 codeHash) external view returns (bool) {
        return blockedCodeHashes_[codeHash];
    }

    function codeHashOf(address a) external view returns (bytes32) {
        return a.codehash;
    }
}