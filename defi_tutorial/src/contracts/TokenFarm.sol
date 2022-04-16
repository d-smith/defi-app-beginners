pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm"; //state variable, stored on the block chain
    DappToken public dappToken;
    DaiToken public daiToken;

    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;
    address[] public stakers;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
    }

    // Stake tokens
    function stakeTokens(uint _amount) public {
        //transfer tokens
        daiToken.transferFrom(msg.sender, address(this), _amount);

        //update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        //add user to stakers only if they haven't staked before
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        //update staking status
        hasStaked[msg.sender] = true;
        isStaking[msg.sender] = true;
    }
}
