// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IQuiver {
    function draw(string memory arrowId) external view returns (bytes memory);

    function set(string memory arrowId, bytes calldata creationCode) external;
}
