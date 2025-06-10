.PHONY: clean build prove verify test verify-test update-proof

# Build the circuit
build:
	nargo compile

# Generate witness
witness:
	nargo execute

# Generate proof using Barretenberg
prove: witness
	bb prove -b ./target/hello_world.json -w ./target/hello_world.gz -o ./target --oracle_hash keccak --output_format bytes_and_fields

# Update proof in ProofData.sol
update-proof:
	@echo "// SPDX-License-Identifier: MIT" > test/ProofData.sol
	@echo "pragma solidity ^0.8.13;" >> test/ProofData.sol
	@echo "" >> test/ProofData.sol
	@echo "contract ProofData {" >> test/ProofData.sol
	@echo "    // The proof bytes will be populated here after generation" >> test/ProofData.sol
	@echo "    bytes public constant PROOF = hex\"$$(cat ./target/proof | xxd -p | tr -d '\n')\";" >> test/ProofData.sol
	@echo "" >> test/ProofData.sol
	@echo "    // The public input from Barretenberg" >> test/ProofData.sol
	@PUBLIC_INPUT=$$(tail -c 1 ./target/public_inputs | xxd -p | tr -d '\n'); \
	echo "    bytes32 public constant PUBLIC_INPUT = bytes32(uint256(0x$$PUBLIC_INPUT));" >> test/ProofData.sol
	@echo "}" >> test/ProofData.sol

# Verify proof
verify:
	nargo verify

# Run tests
test:
	forge test -vvvv

# Clean build artifacts
clean:
	rm -rf target/
	rm -rf build/

# Full workflow: build, generate witness, prove, and verify
all: clean build witness prove verify

# Generate proof and run verification test
verify-test: clean build witness prove update-proof test 