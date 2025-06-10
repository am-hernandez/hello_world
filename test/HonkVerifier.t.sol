// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {HonkVerifier} from "../src/HonkVerifier.sol";
import {ProofData} from "./ProofData.sol";

contract HonkVerifierTest is Test, ProofData {
    HonkVerifier verifier;

    function setUp() public {
        verifier = new HonkVerifier();
    }

    function testVerify() public view {
        bytes32[] memory publicInputs = new bytes32[](1);
        publicInputs[0] = PUBLIC_INPUT;

        console.log("Public Input (hex):");
        console.logBytes32(PUBLIC_INPUT);
        console.log("Public Input (uint):");
        console.log(uint256(PUBLIC_INPUT));

        console.log("Proof length:");
        console.log(PROOF.length);

        // Print first 32 bytes of proof
        bytes memory first32Bytes = new bytes(32);
        for (uint256 i = 0; i < 32 && i < PROOF.length; i++) {
            first32Bytes[i] = PROOF[i];
        }
        console.log("First 32 bytes of proof:");
        console.logBytes(first32Bytes);

        bool result = verifier.verify(PROOF, publicInputs);
        assertTrue(result, "Verification failed");
    }
}
