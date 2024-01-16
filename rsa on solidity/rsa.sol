// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract SimpleRSA {
    uint256 public e; // Public exponent
    uint256 public d; // Private exponent
    uint256 public n; // Modulus

    constructor() {
        // For simplicity, use small prime numbers. In a real-world scenario, use much larger prime numbers.
        uint256 p = 114740557129380026830715235359828960591;//61;
        uint256 q = 147068484937473460195139692250312844029;//53;

        n = p * q;
        uint256 phi = (p - 1) * (q - 1);

        // Choose a public exponent (e) such that 1 < e < phi and gcd(e, phi) = 1
        e = 65537;//17; // Common choice for simplicity

        // Calculate the private exponent (d) such that (d * e) % phi == 1
        d = modInverse(e, phi);
    }

    function encrypt(uint256 message) public view returns (uint256) {
        // Make sure the message is smaller than the modulus
        require(message < n, "Message is too large");

        // Use the public exponent for encryption
        return modPow(message, e, n);
    }

    function decrypt(uint256 encryptedMessage) public view returns (uint256) {
        // Use the private exponent for decryption
        return modPow(encryptedMessage, d, n);
    }

    // Calculate (base^exponent) % modulus efficiently
    function modPow(uint256 base, uint256 exponent, uint256 modulus) internal pure returns (uint256 result) {
        result = 1;
        for (uint256 i = 0; i < exponent; i++) {
            result = (result * base) % modulus;
        }
    }

    // Calculate the modular multiplicative inverse of a number
    function modInverse(uint256 a, uint256 m) internal pure returns (uint256) {
        int256 m0 = int256(m);
        int256 a0 = int256(a);
        int256 y = 0;
        int256 x = 1;

        while (a0 > 1) {
            int256 q = m0 / a0;
            (m0, a0) = (a0, m0 - q * a0);
            (y, x) = (x, y - q * x);
        }

        // Ensure y is positive
        if (y < 0) {
            y += int256(m);
        }

        return uint256(y);
    }
}
