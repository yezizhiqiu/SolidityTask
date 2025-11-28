// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IntegerToRoman {
    function romanToInt(string memory s) public pure returns (uint256) {
        bytes memory roman = bytes(s);
        require(roman.length > 0, "Empty string");

        uint256 result = 0;
        uint256 prev = 0;

        for (uint256 i = 0; i < roman.length; i++) {
            uint256 curr = getValue(roman[i]);
            result += curr;
            if (prev < curr) {
                result -= 2 * prev;
            }
            prev = curr;
        }

        return result;
    }
    function getValue(bytes1 char) private pure returns (uint256) {
        if (char == "I") return 1;
        if (char == "V") return 5;
        if (char == "X") return 10;
        if (char == "L") return 50;
        if (char == "C") return 100;
        if (char == "D") return 500;
        if (char == "M") return 1000;
        revert("Invalid Roman numeral character");
    }
}
