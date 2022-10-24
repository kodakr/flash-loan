const ethers = require("ethers");

const {addressFactory,
addressRouter,
addressFrom,
addressTo} = require ("./addresslist");

const {erc20ABI, factoryAbi, pairABI, routerABI} = require("./getABI");

// standard provider
const INFURA_ID = '3d05647a39544dafab60d295c1ece741';
const provider = new ethers.providers.JsonRpcProvider(`https://mainnet.infura.io/v3/${INFURA_ID}`);
