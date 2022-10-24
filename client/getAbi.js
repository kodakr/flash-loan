const erc20ABI = ["function decimals() external view returns(uint8)"];
const factoryAbi = [
    "function getPair(address tokenA, address tokenB) external view returns (address pair)"
];
const pairABI = [
    "function token0() external view returns (address)",
    "function token1() external view returns (address)",
    "function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast)"
];
const routerABI = [
    "function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts)",
]
module.exports = {erc20ABI, factoryAbi, pairABI, routerABI};