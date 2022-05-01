// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IQuiver} from "./interfaces/IQuiver.sol";

/// The Quiver holds the Arrows that the Hunter shoots.
/// @title Quiver.sol
/// @author @devtooligan
/// @dev CloudHunter is a system for pre-computing, managing and deploying lazy, counterfactual, wallet contracts.
contract Quiver is IQuiver {
    /// The internal registry that tracks the Arrows' creation codes.
    mapping(bytes32 => bytes) internal arrows;

    /// The external getter for Arrows.
    /// @param arrowId Id of arrow in bytes.  Example: "sendEth"
    /// @return The creation code for the Arrow.
    function draw(bytes32 arrowId) external view returns (bytes memory) {
        return arrows[arrowId];
    }

    /// The external setter for arrows.
    /// @param arrowId Id of arrow in bytes.  Example: "sendEth"
    /// @param creationCode The creation code for the Arrow. Obtainable with: type(ArrowContract).creationCode
    /// @return True if successful.
    /// @dev This will overwrite any existing value.  Use with caution.
    function set(bytes32 arrowId, bytes calldata creationCode) external returns (bool) {
        arrows[arrowId] = creationCode;
        return true;
    }
}
