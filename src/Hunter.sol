// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IQuiver} from "./interfaces/IQuiver.sol";
import {AccessControl} from "yield-utils-v2/contracts/access/AccessControl.sol";

/*
                                             |
                                              \.
                                              /|.
                                            /  `|.
                                          /      .
                                        /        |.                       (`  ).        .')        _
                                      /          `|.                     (     ).      (_  )   .:(`  )`.
                                    /             |.                    _(       '`.          :(   .    )
                                  /               |.                .=(`(      .   )     .--  `.  (    ) )
               ^^^^^^^          /                 `|.              ((    (..__.:'-'   .+(   )   ` _`  ) )
              /       \       /                    |.              `(       ) )       (   .  )     (   )  ._
             /|      ` \    /                      |.                ` __.:'   )     (   (   ))     `-'.-(`  )
       _____/ =       =|__/___                     |.                       --'       `- __.(`        :(  (   ))
   ,--' ,----`-,__ ___/'  --,-`-===================##===>   _______ _                 _               `( (_.'
 \                '        ##_______ ______   _____##,__   (_______) |               | |   .')    .').  `
   `,    __==    ___,-,__,--'#'  ==='     .`-'   | ##,-/    _      | | ___  _   _  __| |  (_  )  (_  )
     `-,____,---'       \####\            ____,--\_##,/    | |     | |/ _ \| | | |/ _  |    ..=(`:'-'
         #_         I    |##   \  _____,--         ##      | |_____| | |_| | |_| ( (_| |    ((  )
          #         ♥    ]===--==\                 ||       \______)\_)___/|____/ \____|     (   )
          #,      CLOUDS ]         \               ||                       _     _            -'
           #_            |           \            ,|.                      (_)   (_)             _
            ##_       __/'             \          |.                        _______ _   _ ____ _| |_ _____  ____
             ####='     |                \       ,|.                       |  ___  | | | |  _ (_   _) ___ |/ ___)
              ###       |                  \\    |.                        | |   | | |_| | | | || |_| ____| |
              ##       _'                    \\  |.                        |_|   |_|____/|_| |_| \__)_____)_|
             ###=======]                       \\|.
            ///        |                        /.
            //         |                       |

*/

/// The Hunter draws an Arrow, takes aim at a Cloud, and shoots.
/// @title Hunter.sol
/// @author @devtooligan
/// @dev CloudHunter is a system for pre-computing, managing, and deploying lazy, counterfactual, wallet contracts.
contract Hunter is AccessControl {
    /// The quiver holds the Arrows that can be used to electrify Clouds of nothingness.
    IQuiver public immutable quiver;

    constructor(IQuiver quiver_) {
        quiver = quiver_;
    }

    /// The Hunter draws an Arrow and aims at a Cloud, identifying it's address.
    /// @param arrowId The id of the Arrow in the Quiver which will be used to compute the address.
    /// @param args Previously abi.encoded Arrow constructor arguments.
    /// @param salt User selected salt which allows for optional duplication of contracts.
    /// @return cloud The address of a lazy, counterfactual, wallet contract; a cloud of nothingness.
    /// Before it's deployed, this address can be interacted with normally including sending ETH, tokens, or NFT's.
    function seek(
        bytes32 arrowId,
        bytes calldata args,
        uint256 salt
    ) public view returns (address payable cloud) {
        cloud = payable(
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

    /// Similar to seek(), but instead of using an Arrow out of the Quiver, custom initCode is passed in.
    /// @param initCode This contains both the creationCode and the encoded args of the Arrow contract.
    /// example: abi.encodePacked(type(MyContract).creationCode, abi.encode(constructorArg1, constructorArg2));
    /// @param salt User selected salt which allows for optional duplication of contracts.
    /// @return cloud The address of a cloud of nothingness.
    /// @dev This fn uses calldata which can save gas on external calls.
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

    /// The Hunter draws an Arrow and aims at a Cloud, identifying it's address.
    /// @param arrowId The id of the Arrow in the Quiver which will be used to compute the address.
    /// @param args Previously abi.encoded Arrow constructor arguments.
    /// @param salt User selected salt which allows for optional duplication of contracts.
    /// @return cloud The address of the Cloud that the Arrow contract was deployed to.
    function shoot(
        bytes32 arrowId,
        bytes calldata args,
        uint256 salt
    ) public auth returns (address payable cloud) {
        bytes memory initCode = abi.encodePacked(quiver.draw(arrowId), args);
        return _shoot(initCode, salt);
    }

    /// Similar to shoot(), but instead of using an Arrow out of the Quiver, custom initCode is passed in.
    /// @param initCode This contains both the creationCode and the encoded args of the Arrow contract.
    /// example: abi.encodePacked(type(MyContract).creationCode, abi.encode(constructorArg1, constructorArg2));
    /// @param salt User selected salt which allows for optional duplication of contracts.
    /// @return cloud The address of a cloud of nothingness.
    /// @dev This fn does not use calldata because that would need to be copied into memory anyways.
    function shootCustom(bytes memory initCode, uint256 salt) public auth returns (address payable cloud) {
        return _shoot(initCode, salt);
    }

    /// @dev Internal function used by shoot() and shootCustom()
    function _shoot(bytes memory initCode, uint256 salt) internal virtual returns (address payable cloud) {
        assembly {
            let codeSize := mload(initCode) // get size of initCode
            cloud := create2(
                0, // 0 wei
                add(initCode, 32), // the bytecode starts at the second slot. The first slot contains array length.
                codeSize, // size of init_code
                salt // salt from function arguments
            )
        }
    }
}
