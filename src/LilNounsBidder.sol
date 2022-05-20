// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

interface ILilNouns {
    function createBid(uint256 nounId) external;
}

interface INounsAuctionHouse {
    struct Auction {
        // ID for the Noun (ERC721 token ID)
        uint256 nounId;
        // The current highest bid amount
        uint256 amount;
        // The time that the auction started
        uint256 startTime;
        // The time that the auction is scheduled to end
        uint256 endTime;
        // The address of the current highest bid
        address payable bidder;
        // Whether or not the auction has been settled
        bool settled;
    }

    function auction() external view returns (Auction memory);

    function minBidIncrementPercentage() external view returns (uint8);

    function reservePrice() external view returns (uint256);

    function createBid(uint256 nounId) external payable;
}

contract LilNounsBidder is Ownable {
    event Bid(uint256 nounId, uint256 amount);

    address public lilNounsAuctionHouse;

    constructor(address _lilNounsAuctionHouse) {
        lilNounsAuctionHouse = _lilNounsAuctionHouse;
    }

    modifier onlyOwnerOrSelf() {
        require(msg.sender == owner() || msg.sender == address(this));
        _;
    }

    function bid() external payable onlyOwnerOrSelf {
        INounsAuctionHouse.Auction memory _auction = INounsAuctionHouse(
            lilNounsAuctionHouse
        ).auction();

        require(
            block.timestamp < _auction.endTime,
            "Auction has already has a winner"
        );

        uint256 minimumBid = _minBid(_auction);

        require(
            address(this).balance + msg.value >= minimumBid,
            "insufficient value"
        );

        emit Bid(_auction.nounId, minimumBid);

        INounsAuctionHouse(lilNounsAuctionHouse).createBid{value: minimumBid}(
            _auction.nounId
        );
    }

    function minBid() external view returns (uint256) {
        INounsAuctionHouse.Auction memory _auction = INounsAuctionHouse(
            lilNounsAuctionHouse
        ).auction();

        return _minBid(_auction);
    }

    function _minBid(INounsAuctionHouse.Auction memory _auction)
        internal
        view
        returns (uint256)
    {
        uint256 _bid = _auction.amount +
            ((_auction.amount *
                INounsAuctionHouse(lilNounsAuctionHouse)
                    .minBidIncrementPercentage()) / 100);
        return
            _bid == 0
                ? INounsAuctionHouse(lilNounsAuctionHouse).reservePrice()
                : _bid;
    }

    function call(address target, bytes memory data)
        external
        payable
        onlyOwner
        returns (bool)
    {
        (bool success, ) = target.call{value: msg.value}(data);

        return success;
    }

    receive() external payable {}
}
