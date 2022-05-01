// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Hunter} from "../src/Hunter.sol";
import {Quiver} from "../src/Quiver.sol";
import {AccessControl} from "yield-utils-v2/contracts/access/AccessControl.sol";

// TODO: HunterGatherers = HunterFactory

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

        quiver.set(bytes32("sendEth"), type(Arrow).creationCode);
        bytes memory arrowCode = quiver.draw(bytes32("sendEth"));
        require(keccak256(arrowCode) == keccak256(type(Arrow).creationCode));
        vm.stopPrank();
    }

    function testUnitSeek() public view {
        address payable cloud = hunter.seek(bytes32("sendEth"), args, 1);
        require(cloud != address(0));
    }

    function testUnitSeekCustom() public view {
        address payable cloud = hunter.seek(bytes32("sendEth"), args, 1);
        bytes memory initCode = abi.encodePacked(type(Arrow).creationCode, args);
        address payable cloud2 = hunter.seekCustom(initCode, 1);
        require(cloud2 == cloud);
    }

    function testUnitShoot() public {
        address payable cloud = hunter.seek(bytes32("sendEth"), args, 1);

        vm.startPrank(bob);
        uint256 amount = 5 ether;
        cloud.transfer(amount); // bob transfers 5 eth to the Cloud
        require(alice.balance == 0); // confirm alice balance == 5 eth
        require(cloud.balance == amount); // confirm Cloud balance == 5 eth
        hunter.shoot(bytes32("sendEth"), args, 1); // shoot Arrow at Cloud
        require(cloud.balance == 0); // confirm Cloud balance == 0 eth
        require(alice.balance == amount); // confirm alice balance == 5 eth
    }
    function testUnitShootCustom() public {
        address payable cloud = hunter.seek(bytes32("sendEth"), args, 1);
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
