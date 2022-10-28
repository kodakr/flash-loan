// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "IUniswapFactory.sol";


contract PancakeSwapArbitrage {
    using SafeERC20 for IERC20;
    //using "library" for "interface";

    //public variable
    address private constant PANCAKEFACTORY = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;
    address private constant PANCAKEROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E ;
    // Token Variables
    address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address private constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address private constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address private constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address private constant CROX = 0x2c094F5A7D1146BB93850f629501eB749f6Ed491;

    uint private deadline = block.timestamp + 1 days;
    uint private MAX_VALUE = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    
    //this function enables this contract to hold some token if u wish so.
    function fundThisContract(address _owner, address _token, uint _amt) public {
        IERC20(_token).transferFrom(_owner, address(this), _amt);
    }

    //check this contract.s balance of an input token
    function getThisContractBal(address _token) public  view returns(uint256) {
        return IERC20(_token).balanceOf(address(this));
    }
    // Start arbitrage
    function triggerArb(address _tokenborrow, uint _amount) external {
        IERC20(BUSD).safeApprove(address (PANCAKEROUTER), MAX_VALUE);
        IERC20(USDT).safeApprove(address (PANCAKEROUTER), MAX_VALUE);
        IERC20(CROX).safeApprove(address (PANCAKEROUTER), MAX_VALUE);
        IERC20(CAKE).safeApprove(address (PANCAKEROUTER), MAX_VALUE);

        address Pair = IUniswapV2Factory(PANCAKEFACTORY).getPair(_tokenborrow, WBNB);

        require (Pair != address(0), "Pair is unavailable");
        //figure out which token is (1 or 0)
        address token0 = IUniswapV2Pair(Pair).token0();
        address token1 = IUniswapV2Pair(Pair).token1();
        uint amount0Out = _tokenborrow == token0 ? _amount : 0;
        uint amount1Out = _tokenborrow == token1 ? _amount : 0;

        bytes memory data = abi.encode(_tokenborrow,_amount);
        IUniswapV2Pair(Pair).swap(amount0Out, amount1Out, address(this), data);   
    }

    function pancakeSwap(address _sender, uint _amount0, uint _amount1, bytes calldata data) external {
        //ensure request is from contract
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();
        address Pair = IUniswapV2Factory(PANCAKEFACTORY).getPair(token0, token1);

        require(msg.sender == Pair, "doesnt match the pair");
        require(_sender == address(this), "sender not the contract address");
        //decoding the data for.....
        (address _tokenborrow, uint256 _amount) = abi.decode(data,(address, uint256));

        //calculate repay according to docs.
        uint fee = ((_amount * 3) / 997) +1;
        uint256 payback = _amount + fee;

        /// do arbitrage-- arbitrage opportunities vary. perform as u can
        
        // pay self

        //pay loan bk
        IERC20(_tokenborrow).transfer(Pair, payback);

    }





}
