// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IQuiver} from "./interfaces/IQuiver.sol";

contract Quiver is IQuiver {
    mapping(bytes32 => bytes) internal arrows;

    function draw(bytes32 arrowId) external view returns (bytes memory) {
        return arrows[arrowId];
    }

    function set(bytes32 arrowId, bytes calldata creationCode) external returns (bool) {
        arrows[arrowId] = creationCode;
        return true;
    }

}
