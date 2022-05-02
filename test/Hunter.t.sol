// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Hunter} from "../src/Hunter.sol";
import {Quiver} from "../src/Quiver.sol";
import {ETHArrow, ERC20Arrow, ERC721Arrow} from "../src/Arrows.sol";
import {AccessControl} from "yield-utils-v2/contracts/access/AccessControl.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {MockERC721} from "solmate/test/utils/mocks/MockERC721.sol";



contract HunterTest is Test {
    // internal contracts
    Hunter public hunter;
    Quiver public quiver;

    // mock users
    address payable public alice;
    address payable public bob;

    // reusable args
    bytes public argsETH;
    bytes public argsERC20;
    bytes public argsERC721;

    //mocks
    MockERC20 public erc20;
    MockERC721 public erc721;

    //constants
    uint256 public constant WAD = 1e18;
    uint256 public constant NFT_TOKEN_ID = 1;
    bytes public constant ETH_ARROW = "ethArrow";
    bytes public constant ERC20_ARROW = "erc20Arrow";
    bytes public constant ERC721_ARROW = "erc721Arrow";


    function setUp() public {
        alice = payable(address(0xbae));
        vm.label(alice, "alice");

        bob = payable(address(0xb0b));
        vm.label(bob, "bob");
        vm.deal(bob, 10 ether);

        vm.startPrank(bob);
        quiver = new Quiver();
        hunter = new Hunter(quiver);
        AccessControl(address(hunter)).grantRole(bytes4(hunter.shoot.selector), bob);
        AccessControl(address(hunter)).grantRole(bytes4(hunter.shootCustom.selector), bob);

        bytes memory arrowCode = quiver.draw(bytes32(ETH_ARROW));
        require(keccak256(arrowCode) == keccak256(type(ETHArrow).creationCode));
        vm.stopPrank();

        // setup mocks and mint to bob
        erc20 = new MockERC20("CloudHunter token", "CLOUDHUNT", 18);
        erc721 = new MockERC721("CloudHunter nft", "CLOUDHUNTNFT");

        // setup args
        argsETH = abi.encode(alice);
        argsERC20 = abi.encode(alice, address(erc20));
        argsERC721 = abi.encode(alice, address(erc20), NFT_TOKEN_ID);

    }

    // function testUnitSeek() public view {
    function testUnitSeek() public {
        address payable cloud1 = hunter.seek(bytes32(ETH_ARROW), argsETH, 1);
        require(cloud1 != address(0));

        address payable cloud2 = hunter.seek(bytes32(ERC20_ARROW), argsETH, 1);
        require(cloud2 != address(0));

        address payable cloud3 = hunter.seek(bytes32(ERC721_ARROW), argsETH, 1);
        require(cloud3 != address(0));
    }

    function testUnitSeekCustom() public view {
        address payable cloud1 = hunter.seek(bytes32(ETH_ARROW), argsETH, 1);
        bytes memory initCode1 = abi.encodePacked(type(ETHArrow).creationCode, argsETH);
        address payable cloudCustom1 = hunter.seekCustom(initCode1, 1);
        require(cloudCustom1 == cloud1);

        address payable cloud2 = hunter.seek(bytes32(ERC20_ARROW), argsETH, 1);
        bytes memory initCode2 = abi.encodePacked(type(ERC20Arrow).creationCode, argsETH);
        address payable cloudCustom2 = hunter.seekCustom(initCode2, 1);
        require(cloudCustom2 == cloud2);

        address payable cloud3 = hunter.seek(bytes32(ERC721_ARROW), argsETH, 1);
        bytes memory initCode3 = abi.encodePacked(type(ERC721Arrow).creationCode, argsETH);
        address payable cloudCustom3 = hunter.seekCustom(initCode3, 1);
        require(cloudCustom3 == cloud3);

    }

    function testUnitShootETH() public {
        address payable cloud = hunter.seek(bytes32(ETH_ARROW), argsETH, 1);
        vm.startPrank(bob);
        uint256 amount = 5 ether;
        cloud.transfer(amount); // bob transfers 5 eth to the Cloud
        require(alice.balance == 0); // confirm alice balance == 0 eth
        require(cloud.balance == amount); // confirm Cloud balance == 5 eth
        hunter.shoot(bytes32(ETH_ARROW), argsETH, 1); // shoot Arrow at Cloud
        require(cloud.balance == 0); // confirm Cloud balance == 0 eth
        require(alice.balance == amount); // confirm alice balance == 5 eth
    }

    function testUnitShootERC20() public {
        address payable cloud = hunter.seek(bytes32(ERC20_ARROW), argsERC20, 1);
        uint256 amount = 5 * WAD;
        erc20.mint(cloud, amount); // mint 5 tokens to cloud
        require(erc20.balanceOf(alice) == 0); // confirm alice balance == 0 tokens
        require(erc20.balanceOf(cloud) == amount); // confirm Cloud balance == 5 tokens

        vm.prank(bob);
        hunter.shoot(bytes32(ERC20_ARROW), argsERC20, 1); // shoot Arrow at Cloud

        require(erc20.balanceOf(cloud) == 0); // confirm Cloud balance == 0 tokens
        require(erc20.balanceOf(alice) == amount); // confirm alice balance == 5 tokens
    }

    function testUnitShootERC721() public {
        address payable cloud = hunter.seek(bytes32(ERC721_ARROW), argsERC721, 1);
        erc721.mint(cloud, 1); // mint 1 nft to cloud
        require(erc721.ownerOf(1) == cloud); // confirm Cloud holds 1 nft

        vm.prank(bob);
        hunter.shoot(bytes32(ERC721_ARROW), argsERC721, 1); // shoot Arrow at Cloud

        require(erc721.ownerOf(1) == cloud); // confirm alice holds 1 nft
    }

    function testUnitShootCustomETH() public {
        address payable cloud = hunter.seek(bytes32(ETH_ARROW), argsETH, 1);
        bytes memory initCode = abi.encodePacked(type(ETHArrow).creationCode, argsETH);
        uint256 amount = 5 ether;
        vm.startPrank(bob);
        cloud.transfer(amount); // bob transfers 5 eth to the Cloud
        require(alice.balance == 0); // confirm alice balance == 5 eth
        require(cloud.balance == amount); // confirm Cloud balance == 5 eth

        hunter.shootCustom(initCode, 1); // shoot Arrow at Cloud

        require(cloud.balance == 0); // confirm Cloud balance == 0 eth
        require(alice.balance == amount); // confirm alice balance == 5 eth
    }

    function testUnitShootCustomERC20() public {
        address payable cloud = hunter.seek(bytes32(ERC20_ARROW), argsERC20, 1);
        bytes memory initCode = abi.encodePacked(type(ERC20Arrow).creationCode, argsERC20);
        uint256 amount = 5 * WAD;
        erc20.mint(cloud, amount); // mint 5 tokens to cloud
        require(erc20.balanceOf(alice) == 0); // confirm alice balance == 0 tokens
        require(erc20.balanceOf(cloud) == amount); // confirm Cloud balance == 5 tokens

        vm.prank(bob);
        hunter.shootCustom(initCode, 1); // shoot Arrow at Cloud

        require(erc20.balanceOf(cloud) == 0); // confirm Cloud balance == 0 tokens
        require(erc20.balanceOf(alice) == amount); // confirm alice balance == 5 tokens
    }

    function testUnitShootCustomERC721() public {
        address payable cloud = hunter.seek(bytes32(ERC721_ARROW), argsERC721, 1);
        bytes memory initCode = abi.encodePacked(type(ERC721Arrow).creationCode, argsERC721);

        erc721.mint(cloud, 1); // mint 1 nft to cloud
        require(erc721.ownerOf(1) == cloud); // confirm Cloud holds 1 nft

        vm.prank(bob);
        hunter.shootCustom(initCode, 1); // shoot Arrow at Cloud

        require(erc721.ownerOf(1) == cloud); // confirm alice holds 1 nft
    }
}
