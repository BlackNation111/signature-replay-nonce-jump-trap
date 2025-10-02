// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NonceResponse
/// 
@notice
 Simple protective response contract that Drosera operators call when NonceReplayTrap detects an anomaly.
/// It records flagged signers and optionally "locks" them (logical flag) so downstream systems can act.
contract NonceResponse {
    address public owner;

    // flagged signers (detected anomalies)
    mapping(address => bool) public flagged;
    // locked signers (operator decision or automatic)
    mapping(address => bool) public locked;

    event NonceAlert(
        address indexed signer,
        uint256 prevNonce,
        uint256 currNonce,
        uint256 delta,
        string reason,
        uint256 blockNumber,
        address reporter
    );

    event SignerLocked(address indexed signer, address locker);
    event SignerUnlocked(address indexed signer, address locker);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwnerOrReporter() {
        // For PoC we permit owner only for critical ops.
        require(msg.sender == owner, "only owner");
        _;
    }

    /// Called by Drosera operator when trap signals an anomaly.
    /// Matches the payload encoded in NonceReplayTrap.shouldRespond.
    function respondWithNonceAlert(
        address signer,
        uint256 prevNonce,
        uint256 currNonce,
        uint256 delta,
        string calldata reason,
        uint256 blockNumber
    ) external {
        // Record and emit event
        flagged[signer] = true;
        emit NonceAlert(signer, prevNonce, currNonce, delta, reason, blockNumber, msg.sender);

        // Optionally, auto-lock if delta is large (for PoC we do not auto-lock; operator can call lockSigner)
    }

    /// Owner can lock a signer (logical lock for downstream automation)
    function lockSigner(address signer) external onlyOwnerOrReporter {
        locked[signer] = true;
        emit SignerLocked(signer, msg.sender);
    }

    /// Owner can unlock
    function unlockSigner(address signer) external onlyOwnerOrReporter {
        locked[signer] = false;
        emit SignerUnlocked(signer, msg.sender);
    }

    /// View helpers
    function isFlagged(address signer) external view returns (bool) {
        return flagged[signer];
    }

    function isLocked(address signer) external view returns (bool) {
        return locked[signer];
    }
}
