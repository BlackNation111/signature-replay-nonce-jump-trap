// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SignerMock
/// 
@notice
 Simple mock representing a smart-wallet or signer that exposes a nonce and lastSignatureHash.
/// Use this for testing the NonceReplayTrap in Remix/Hardhat.
contract SignerMock {
    uint256 private _nonce;
    bytes32 private _lastSigHash;

    event NonceSet(uint256 nonce);
    event SigSet(bytes32 sig);
    event SimulatedTx(bytes32 sig, uint256 newNonce);

    constructor(uint256 initialNonce, bytes32 initialSig) {
        _nonce = initialNonce;
        _lastSigHash = initialSig;
    }

    function getNonce() external view returns (uint256) {
        return _nonce;
    }

    function lastSignatureHash() external view returns (bytes32) {
        return _lastSigHash;
    }

    // test helpers
    function setNonce(uint256 n) external {
        _nonce = n;
        emit NonceSet(n);
    }

    function setLastSignatureHash(bytes32 h) external {
        _lastSigHash = h;
        emit SigSet(h);
    }

    /// Simulate a transaction signed with sig (set lastSigHash and increment nonce)
    function simulateTx(bytes32 sig) external {
        _lastSigHash = sig;
        _nonce += 1;
        emit SimulatedTx(sig, _nonce);
    }

    /// Simulate a replay: set the same signature without incrementing nonce (for testing repeated signature detection)
    function simulateReplay(bytes32 sig) external {
        _lastSigHash = sig;
        emit SigSet(sig);
    }
}
