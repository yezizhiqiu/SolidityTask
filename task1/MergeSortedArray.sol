// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MergeSortedArray {
    /**
     * @dev 合并两个有序数组
     * @param nums1 第一个有序数组
     * @param nums2 第二个有序数组  
     * @return 合并后的有序数组
     */
    function merge(
        uint256[] memory nums1,
        uint256[] memory nums2
    ) public pure returns (uint256[] memory) {
        uint256 m = nums1.length;
        uint256 n = nums2.length;
        uint256[] memory result = new uint256[](m + n);
        
        uint256 i = 0; // nums1 指针
        uint256 j = 0; // nums2 指针
        uint256 k = 0; // result 指针
        
        // 比较两个数组的元素，选择较小的放入结果
        while (i < m && j < n) {
            if (nums1[i] < nums2[j]) {
                result[k] = nums1[i];
                i++;
            } else {
                result[k] = nums2[j];
                j++;
            }
            k++;
        }
        
        // 将剩余元素复制到结果
        while (i < m) {
            result[k] = nums1[i];
            i++;
            k++;
        }
        
        while (j < n) {
            result[k] = nums2[j];
            j++;
            k++;
        }
        
        return result;
    }
}