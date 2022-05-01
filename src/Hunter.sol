// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {IQuiver} from "./interfaces/IQuiver.sol";
import {AccessControl} from "yield-utils-v2/contracts/access/AccessControl.sol";


contract Hunter is AccessControl {
    IQuiver public immutable quiver;

    constructor(IQuiver quiver_) {
        quiver = quiver_;
    }

    //
    function seek(
        bytes32 arrowId,
        bytes calldata args,
        uint256 salt
    ) public view returns (address payable) {
        return
            payable(
                address(
                    uint160(
                        uint256(
                            keccak256(
                                abi.encodePacked(
                                    bytes1(0xff),
                                    address(this),
                                    salt,
                                    keccak256(abi.encodePacked(quiver.draw(arrowId), args))
                                )
                            )
                        )
                    )
                )
            );
    }

    // uses calldata
    function seekCustom(bytes calldata initCode, uint256 salt) public view returns (address payable) {
        return
            payable(
                address(
                    uint160(
                        uint256(keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(initCode))))
                    )
                )
            );
    }

    function shoot(
        bytes32 arrowId,
        bytes calldata args,
        uint256 salt
    ) public auth returns (address cloud) {
        bytes memory initCode = abi.encodePacked(quiver.draw(arrowId), args);
        return shootCustom(initCode, salt);
    }

    function shootCustom(bytes memory initCode, uint256 salt) public auth returns (address cloud) {
        uint256 start = gasleft();
        assembly {
            let codeSize := mload(initCode) // get size of initCode
            cloud := create2(
                0, // 0 wei
                add(initCode, 32), // the bytecode itself starts at the second slot. The first slot contains array length
                codeSize, // size of init_code
                salt // salt from function arguments
            )
        }
        console.log("gas", start - gasleft() - 2);
    }
}
