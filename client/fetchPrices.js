const ethers = require("ethers");

const {addressFactory,
addressRouter,
addressFrom,
addressTo} = require ("./addresslist");

const {erc20ABI, factoryAbi, pairABI, routerABI} = require("./getABI");

// standard provider
const INFURA_ID = '';
const provider = new ethers.providers.JsonRpcProvider(`https://mainnet.infura.io/v3/${INFURA_ID}`);

// //connect to factory
const contractFactory = new ethers.Contract(addressFactory,factoryAbi,provider);
const contractRouter = new ethers.Contract(addressRouter,routerABI,provider);

// connect to blockchain
const getPrices = async (amountInHuman) => {
    const contractToken = new ethers.Contract(addressFrom, erc20ABI,provider);
    const decimal = await contractToken.decimals();
    const amountIn = ethers.utils.parseUnits(amountInHuman, decimal).toString();
    console.log(amountIn);
    
    // amountOut
    const Out = await contractRouter.getAmountsOut(amountIn, [addressFrom,addressTo]);
    
   // amountsOut to decimal;
   const ab2 = new ethers.Contract(addressTo, erc20ABI, provider);
   const decimal2 = await ab2.decimals();
   const decimalOut = ethers.utils.formatUnits(Out[1].toString(), decimal2);
   console.log(decimalOut);
}


const amount = "2";
getPrices(amount);
