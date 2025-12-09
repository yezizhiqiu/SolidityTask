// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 导入 OpenZeppelin 库
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, ERC721URIStorage, Ownable {
    // 计数器，跟踪下一个 tokenId
    uint256 private _nextTokenId;

    constructor(
        string memory name,
        string memory symbol
    )
        ERC721(name, symbol) // 调用父类构造函数
        Ownable(msg.sender) // 设置部署者为所有者
    {
        // 不需要其他初始化
    }

    function mintNFT(
        address recipient,
        string memory tokenURI
    )
        public
        onlyOwner // 只有所有者可以调用
        returns (uint256)
    {
        // 获取当前 tokenId
        uint256 tokenId = _nextTokenId;

        // 递增 tokenId 计数器，为下一次铸造准备
        _nextTokenId++;

        // 铸造 NFT 给接收者
        _safeMint(recipient, tokenId);

        // 设置 tokenURI（元数据链接）
        _setTokenURI(tokenId, tokenURI);

        // 返回 tokenId
        return tokenId;
    }

    function batchMintNFT(
        address[] memory recipients,
        string[] memory tokenURIs
    ) public onlyOwner {
        require(
            recipients.length == tokenURIs.length,
            unicode"MyNFT: 数组长度不匹配"
        );

        for (uint256 i = 0; i < recipients.length; i++) {
            mintNFT(recipients[i], tokenURIs[i]);
        }
    }

    function getNextTokenId() public view returns (uint256) {
        return _nextTokenId;
    }

    function totalSupply() public view returns (uint256) {
        return _nextTokenId;
    }

    // ========== 以下是必需的覆盖函数 ==========

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
