// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;



interface IERC20 {

    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
}

/// This arrow transfers eth and self destructs.
contract ETHArrow {
    constructor(address payable misterX) {
        selfdestruct(misterX);
    }
}

/// This arrow transfers the balance of one ERC20 token, then self destructs. From selfdestruct, it also sends all eth.
contract ERC20Arrow {
    constructor(address payable misterX, IERC20 token ) {
        token.transfer(misterX, token.balanceOf(address(this)));
        selfdestruct(misterX);
    }
}

/// This arrow transfers one ERC721 token and self destructs.  When selfdestructing it also sends all eth.
contract ERC721Arrow {
    constructor(address payable misterX, IERC721 token, uint256 tokenId) {
        token.transferFrom(address(this), misterX, tokenId);
        selfdestruct(misterX);
    }
}


/// This arrow transfers one ERC721 nft and self destructs.
