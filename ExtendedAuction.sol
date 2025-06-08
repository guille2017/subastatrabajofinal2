// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExtendedAuction {
    // State variables
    address public owner;
    address public highestBidder;
    uint public highestBid;
    uint public auctionEndTime;
    uint public auctionDuration; // in seconds, e.g., 1 hour = 3600
    uint public extensionTime = 10 minutes; // extension duration
    uint public minIncrementPercent = 5; // 5%

    // Events
    event AuctionStarted(address owner, uint startTime, uint endTime);
    event NewHighestBid(address bidder, uint bidAmount, uint newEndTime);
    event AuctionExtended(uint newEndTime);
    event AuctionEnded(address winner, uint bidAmount);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier beforeEnd() {
        require(block.timestamp < auctionEndTime, "Auction already ended");
        _;
    }

    modifier validBid() {
        require(msg.sender != address(0), "Invalid bidder");
        require(msg.value > 0, "Bid amount must be greater than zero");
        require(
            msg.value >= highestBid + (highestBid * minIncrementPercent) / 100,
            "Bid must be at least 5% higher than current highest bid"
        );
        _;
    }

    /**
     * @dev Constructor initializes the auction with a specified duration.
     * @param _duration Duration of the auction in seconds.
     */
    constructor(uint _duration) {
        require(_duration > 0, "Duration must be greater than zero");
        owner = msg.sender;
        auctionDuration = _duration;
        auctionEndTime = block.timestamp + _duration;
        emit AuctionStarted(owner, block.timestamp, auctionEndTime);
    }

    /**
     * @dev Place a bid on the auction.
     */
    function placeBid() external payable beforeEnd validBid {
        // Refund previous highest bidder
        if (highestBidder != address(0)) {
            payable(highestBidder).transfer(highestBid);
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        // Check if bid is within last 10 minutes
        if (auctionEndTime - block.timestamp <= 10 minutes) {
            auctionEndTime += 10 minutes;
            emit AuctionExtended(auctionEndTime);
        }

        emit NewHighestBid(msg.sender, msg.value, auctionEndTime);
    }

    /**
     * @dev End the auction and transfer funds to the owner.
     */
    function endAuction() external {
        require(block.timestamp >= auctionEndTime, "Auction is still ongoing");
        emit AuctionEnded(highestBidder, highestBid);
        // Transfer funds to owner
        payable(owner).transfer(highestBid);
        // Reset state (optional if auction is to be restarted)
    }

    /**
     * @dev Get remaining time of the auction.
     * @return seconds remaining
     */
    function getRemainingTime() external view returns (uint) {
        if (block.timestamp >= auctionEndTime) {
            return 0;
        } else {
            return auctionEndTime - block.timestamp;
        }
    }
}
