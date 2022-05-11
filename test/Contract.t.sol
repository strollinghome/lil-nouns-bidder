// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/LilNounsBidder.sol";

contract ContractTest is Test {
    function setUp() public {}

    function testExample() public {
        address lilNounsAddress = address(
            0x55e0F7A3bB39a28Bd7Bcc458e04b3cF00Ad3219E
        );

        LilNounsBidder lilBidder = new LilNounsBidder(lilNounsAddress);

        lilBidder.bid();

        assertTrue(true);
    }
}
