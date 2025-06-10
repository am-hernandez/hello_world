# Noir + Foundry Zero Knowledge Proof Project

This project demonstrates zero-knowledge proof generation and verification using Noir and Foundry.

## Prerequisites

- [Noir](https://noir-lang.org/) - The domain-specific language for writing zero-knowledge circuits
- [Foundry](https://book.getfoundry.sh/) - For Solidity development and testing
- [Barretenberg](https://github.com/AztecProtocol/barretenberg) - The proving backend that generates proofs compatible with Solidity verifiers

## Project Structure

- `src/main.nr` - Noir circuit implementation
- `src/HonkVerifier.sol` - Solidity verifier contract
- `test/HonkVerifier.t.sol` - Foundry tests for verification
- `test/ProofData.sol` - Contract containing the generated proof and public input

## Proof Generation and Verification

### Barretenberg Proving Backend

Barretenberg is the proving backend that generates proofs compatible with Solidity verifiers. It's crucial for our workflow because:

1. It generates proofs in a format that can be verified on-chain
2. It supports the Honk protocol, which is optimized for Solidity verification
3. It provides the necessary tools to generate verification keys and proofs

### Proof Generation for Solidity

To generate proofs that work with our Solidity verifier, we need to:

1. Use the `--oracle_hash keccak` flag when generating proofs

   - This ensures the proof uses Keccak hash, which is more efficient in Solidity
   - Without this flag, the proof won't be compatible with our verifier

2. Use the `--output_format bytes_and_fields` flag

   - This generates the proof in a format that can be easily converted to Solidity bytes

3. Update the proof in `ProofData.sol`
   - The `update-proof` target automatically converts the proof to a Solidity-compatible format
   - It also extracts and formats the public input

## Usage

### Build and Test Workflow

The simplest way to generate a proof and test verification:

```shell
make verify-test
```

This command will:

1. Clean existing artifacts
2. Build the Noir circuit
3. Generate a new proof (with keccak hash for Solidity compatibility)
4. Update the proof in `ProofData.sol`
5. Run the Foundry verification test

### Individual Commands

```shell
# Build the Noir circuit
make build

# Generate a witness
make witness

# Generate a proof (with keccak hash for Solidity compatibility)
make prove

# Update the proof in ProofData.sol
make update-proof

# Verify the proof using Noir
make verify

# Run Foundry tests
make test

# Clean build artifacts
make clean
```

## Development

### Noir Circuit

The circuit in `src/main.nr` implements a simple comparison:

```rust
fn main(x: Field, y: pub Field) {
    assert(x != y, "x and y must be different");
}
```

### Testing

The Foundry test in `test/HonkVerifier.t.sol` verifies the proof using the HonkVerifier contract. The proof and public input are stored in `test/ProofData.sol`, which is automatically updated when generating a new proof.

## License

MIT
