// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RomanToInteger {
    /**
     * @dev 将罗马数字转换为整数
     * @param s 罗马数字字符串
     * @return 对应的整数值
     */
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
        if (char == 'I') return 1;
        if (char == 'V') return 5;
        if (char == 'X') return 10;
        if (char == 'L') return 50;
        if (char == 'C') return 100;
        if (char == 'D') return 500;
        if (char == 'M') return 1000;
        revert("Invalid Roman character");
    }
    
    /**
     * @dev 验证罗马数字并转换，不会revert
     */
    function safeRomanToInt(string memory s) private  pure returns (uint256 result, bool success) {
        bytes memory roman = bytes(s);
        if (roman.length == 0) {
            return (0, false);
        }
        
        result = 0;
        uint256 prev = 0;
        
        for (uint256 i = 0; i < roman.length; i++) {
            // 手动验证每个字符
            uint256 curr;
            if (roman[i] == 'I') curr = 1;
            else if (roman[i] == 'V') curr = 5;
            else if (roman[i] == 'X') curr = 10;
            else if (roman[i] == 'L') curr = 50;
            else if (roman[i] == 'C') curr = 100;
            else if (roman[i] == 'D') curr = 500;
            else if (roman[i] == 'M') curr = 1000;
            else return (0, false); // 无效字符
            
            result += curr;
            if (prev < curr) {
                if (result < 2 * prev) return (0, false); // 防止下溢
                result -= 2 * prev;
            }
            prev = curr;
        }
        
        success = true;
    }
    
    /**
     * @dev 简单的验证函数
     */
    function isValidRoman(string memory s) private pure returns (bool) {
        (, bool success) = safeRomanToInt(s);
        return success;
    }
}