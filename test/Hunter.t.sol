// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Hunter} from "../src/Hunter.sol";
import {Quiver} from "../src/Quiver.sol";
import {ETHArrow, ERC20Arrow, ERC721Arrow} from "../src/Arrows.sol";
import {AccessControl} from "yield-utils-v2/contracts/access/AccessControl.sol";


/// This arrow transfers eth and self destructs.
contract Arrow {
    constructor(address payable misterX) {
        selfdestruct(misterX);
    }
}

/// This arrow transfers one ERC20 token and self destructs.
/// This arrow transfers one ERC721 nft and self destructs.


contract HunterTest is Test {
    Hunter public hunter;
    Arrow public arrow;
    Quiver public quiver;
    address payable public alice;
    address payable public bob;
    bytes public args;

    function setUp() public {
        alice = payable(address(0xbae));
        vm.label(alice, "alice");

        args = abi.encode(alice);


        bob = payable(address(0xb0b));
        vm.label(bob, "bob");
        vm.deal(bob, 10 ether);

        vm.startPrank(bob);
        quiver = new Quiver();
        hunter = new Hunter(quiver);
        AccessControl(address(hunter)).grantRole(bytes4(hunter.shoot.selector), bob);
        AccessControl(address(hunter)).grantRole(bytes4(hunter.shootCustom.selector), bob);

        bytes memory arrowCode = quiver.draw(bytes32("ethArrow"));
        require(keccak256(arrowCode) == keccak256(type(ETHArrow).creationCode));
        vm.stopPrank();
    }

    function testUnitSeek() public view {
        address payable cloud1 = hunter.seek(bytes32("ethArrow"), args, 1);
        require(cloud1 != address(0));

        address payable cloud2 = hunter.seek(bytes32("erc20Arrow"), args, 1);
        require(cloud2 != address(0));

        address payable cloud3 = hunter.seek(bytes32("erc721Arrow"), args, 1);
        require(cloud3 != address(0));
    }

    function testUnitSeekCustom() public view {
        address payable cloud1 = hunter.seek(bytes32("ethArrow"), args, 1);
        bytes memory initCode1 = abi.encodePacked(type(ETHArrow).creationCode, args);
        address payable cloudCustom1 = hunter.seekCustom(initCode1, 1);
        require(cloudCustom1 == cloud1);

        address payable cloud2 = hunter.seek(bytes32("erc20Arrow"), args, 1);
        bytes memory initCode2 = abi.encodePacked(type(ERC20Arrow).creationCode, args);
        address payable cloudCustom2 = hunter.seekCustom(initCode2, 1);
        require(cloudCustom2 == cloud2);

        address payable cloud3 = hunter.seek(bytes32("erc721Arrow"), args, 1);
        bytes memory initCode3 = abi.encodePacked(type(ERC721Arrow).creationCode, args);
        address payable cloudCustom3 = hunter.seekCustom(initCode3, 1);
        require(cloudCustom3 == cloud3);

    }

    function testUnitShoot() public {
        // TODO: Finish up tests -- need to add mocks of erc20 and erc721
        address payable cloud = hunter.seek(bytes32("ethArrow"), args, 1);

        vm.startPrank(bob);
        uint256 amount = 5 ether;
        cloud.transfer(amount); // bob transfers 5 eth to the Cloud
        require(alice.balance == 0); // confirm alice balance == 5 eth
        require(cloud.balance == amount); // confirm Cloud balance == 5 eth
        hunter.shoot(bytes32("ethArrow"), args, 1); // shoot Arrow at Cloud
        require(cloud.balance == 0); // confirm Cloud balance == 0 eth
        require(alice.balance == amount); // confirm alice balance == 5 eth

    }
    function testUnitShootCustom() public {
        address payable cloud = hunter.seek(bytes32("ethArrow"), args, 1);
        bytes memory initCode = abi.encodePacked(type(Arrow).creationCode, abi.encode(alice));

        vm.startPrank(bob);
        uint256 amount = 5 ether;
        cloud.transfer(amount); // bob transfers 5 eth to the Cloud
        require(alice.balance == 0); // confirm alice balance == 5 eth
        require(cloud.balance == amount); // confirm Cloud balance == 5 eth
        hunter.shootCustom(initCode, 1); // shoot Arrow at Cloud
        require(cloud.balance == 0); // confirm Cloud balance == 0 eth
        require(alice.balance == amount); // confirm alice balance == 5 eth
    }
}
