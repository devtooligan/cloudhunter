// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IQuiver {
    function draw(bytes32 arrowId) external view returns (bytes memory);

    function set(bytes32 arrowId, bytes calldata creationCode) external returns (bool);
}
