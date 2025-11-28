// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BinarySearch {
    function search(
        uint256[] memory nums,
        uint256 target
    ) public pure returns (uint256, uint256) {
        if (nums.length == 0) return (type(uint256).max, 0);

        // 检测数组顺序：升序还是降序
        bool isAscending = nums[0] <= nums[nums.length - 1];

        uint256 left = 0;
        uint256 right = nums.length - 1;
        uint256 count = 0;
        while (left <= right) {
            uint256 mid = left + (right - left) / 2;
            count++;
            if (nums[mid] == target) {
                return (mid, count);
            }

            if (isAscending) {
                // 升序数组
                if (nums[mid] < target) {
                    left = mid + 1;
                } else {
                    right = mid - 1;
                }
            } else {
                // 降序数组
                if (nums[mid] > target) {
                    left = mid + 1;
                } else {
                    right = mid - 1;
                }
            }
        }

        return (type(uint256).max, count);
    }
}
