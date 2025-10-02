Nonce Replay / Nonce Jump Trap

This trap is designed to detect suspicious nonce behavior that may indicate a compromised signer or automated replay attack.

Purpose
•Catch irregular nonce activity such as large jumps, duplicate usage, or replay-like sequences.
•Protects key signers from being exploited across chains or via automated bots.

How it works
•Monitors the nonce sequence of important signer addresses.
•Flags:
•Sudden large nonce gaps (nonce > last + N)
•Duplicate nonces (reused values)
•Replays (same signature used across chains or contracts)

Signals
•Nonce jumps beyond expected sequence.
•Same signature appearing in multiple places.
•Repeated low-level calls that don’t match normal signer behavior.

Response

When triggered, the trap:
•Locks the signer key.
•Alerts governance.
•Publishes transaction snapshots for review.
