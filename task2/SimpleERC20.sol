// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev ERC20 标准接口
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev 简单的 ERC20 代币合约
 */
contract SimpleERC20 is IERC20 {
    string public name;
    string public symbol;
    uint8 public immutable decimals;
    uint256 private _totalSupply;
    
    address public owner;
    
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    /**
     * @dev 构造函数，初始化代币
     * @param _name 代币名称
     * @param _symbol 代币符号
     * @param _decimals 小数位数
     * @param initialSupply 初始供应量
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = msg.sender;
        
        _totalSupply = initialSupply * 10 ** _decimals;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    
    /**
     * @dev 返回总供应量
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    
    /**
     * @dev 返回账户余额
     * @param account 要查询的地址
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    
    /**
     * @dev 转账代币
     * @param to 接收地址
     * @param amount 转账数量
     */
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[msg.sender] >= amount, "ERC20: insufficient balance");
        
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    /**
     * @dev 查询授权额度
     * @param _owner 代币持有者
     * @param spender 被授权者
     */
    function allowance(address _owner, address spender) public view override returns (uint256) {
        return _allowances[_owner][spender];
    }
    
    /**
     * @dev 授权额度
     * @param spender 被授权者
     * @param amount 授权数量
     */
    function approve(address spender, uint256 amount) public override returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");
        
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    /**
     * @dev 从授权地址转账
     * @param from 代币来源地址
     * @param to 接收地址
     * @param amount 转账数量
     */
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= amount, "ERC20: insufficient balance");
        require(_allowances[from][msg.sender] >= amount, "ERC20: insufficient allowance");
        
        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][msg.sender] -= amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
    
    /**
     * @dev 增发代币（仅所有者）
     * @param to 接收地址
     * @param amount 增发数量（包含小数位）
     */
    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        require(to != address(0), "ERC20: mint to the zero address");
        
        _totalSupply += amount;
        _balances[to] += amount;
        
        emit Transfer(address(0), to, amount);
    }
    
    /**
     * @dev 转移合约所有权
     * @param newOwner 新所有者地址
     */
    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Only owner can transfer ownership");
        require(newOwner != address(0), "New owner is the zero address");
        owner = newOwner;
    }
}