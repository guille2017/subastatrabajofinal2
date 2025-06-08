
## Additional Considerations:
 - @title Auction Contract with Extended Features
 - @author 
 - @notice This contract allows participants to place bids on an item with specific rules:
 - Bids must be at least 5% higher than the current highest bid.
 - If a bid is placed within the last 10 minutes, the auction extends by 10 minutes.
 - Uses modifiers for validation and access control.
 - Emits events to notify about state changes.
 



# Extended Auction Contract

## Overview
This Solidity contract implements an auction with advanced features:
- Bids must be at least 5% higher than the current highest bid.
- If a bid is placed within the last 10 minutes, the auction is extended by 10 minutes.
- Uses modifiers for validation and access control.
- Emits events to notify participants of key actions.
- Designed for security and robustness.

## Functions
- `constructor(uint _duration)`: Initializes the auction with a specified duration.
- `placeBid() payable`: Allows participants to place bids, ensuring they meet the minimum increment.
- `endAuction()`: Ends the auction and transfers the highest bid to the owner.
- `getRemainingTime() view`: Returns the remaining time for the auction.

## Variables
- `owner`: Address of the auction creator.
- `highestBidder`: Address of the current highest bidder.
- `highestBid`: Amount of the highest bid.
- `auctionEndTime`: Timestamp when the auction ends.
- `auctionDuration`: Duration of the auction.
- `extensionTime`: Duration of extension if bid is placed late.
- `minIncrementPercent`: Minimum percentage increase for new bids.

## Events
- `AuctionStarted(address owner, uint startTime, uint endTime)`: Emitted when the auction starts.
- `NewHighestBid(address bidder, uint bidAmount, uint newEndTime)`: Emitted on new highest bid.
- `AuctionExtended(uint newEndTime)`: Emitted when the auction is extended.
- `AuctionEnded(address winner, uint bidAmount)`: Emitted when the auction ends.

## Usage
1. Deploy the contract with desired duration.
2. Participants call `placeBid()` with their bid amount.
3. When the auction time elapses, call `endAuction()` to finalize and transfer funds.
