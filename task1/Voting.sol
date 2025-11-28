// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Voting {
    // 存储候选人得票数的 mapping
    mapping(string => uint256) public candidateVotes;
    
    // 存储所有候选人的数组（用于重置功能）
    string[] private candidateList;
     // 记录已经投票的地址，防止重复投票
    mapping(address => bool) public hasVoted;
    // 合约所有者
    address public owner;
     // 修饰器：只有所有者可以调用
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    // 修饰器：确保没有重复投票
    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted");
        _;
    }
    
    constructor() {
        //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        owner = msg.sender;
    }
    // 投票函数
    function vote(string memory candidate) public hasNotVoted {
        require(bytes(candidate).length > 0, "Candidate name cannot be empty");
        
        // 如果是新候选人，添加到列表
        if (candidateVotes[candidate] == 0) {
            candidateList.push(candidate);
        }
        
        // 增加候选人得票数
        candidateVotes[candidate]++;
        
        // 标记该地址已投票
        hasVoted[msg.sender] = true;
        
    }
    // 获取候选人得票数
    function getVotes(string memory candidate) public view returns (uint256) {
        require(bytes(candidate).length > 0, "Candidate name cannot be empty");
        return candidateVotes[candidate];
    }

    // 重置所有候选人的得票数
    function resetVotes() public onlyOwner {
        // 遍历所有候选人，重置得票数
        for (uint256 i = 0; i < candidateList.length; i++) {
            candidateVotes[candidateList[i]] = 0;
        }
        
        // 清空候选人列表
        delete candidateList;
        
        // 注意：这里不重置 hasVoted，因为投票记录应该保留
    }
}
