// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./LilNounsBidder.sol";

contract Contract {
    address lilNounsAddress =
        address(0x55e0F7A3bB39a28Bd7Bcc458e04b3cF00Ad3219E);

    function run() public {
        LilNounsBidder lilBidder = new LilNounsBidder(lilNounsAddress);

        lilBidder.minBid();

        lilBidder.bid();

        lilBidder.call{value: lilBidder.minBid()}(
            address(lilBidder),
            abi.encodeCall(lilBidder.bid, ())
        );
    }
}
