const ethers = require("ethers");

const {addressFactory,
addressRouter,
addressFrom,
addressTo} = require ("./addresslist");

const {erc20ABI, factoryAbi, pairABI, routerABI} = require("./getABI");

// standard provider
const INFURA_ID = '';
const provider = new ethers.providers.JsonRpcProvider(`https://mainnet.infura.io/v3/${INFURA_ID}`);
