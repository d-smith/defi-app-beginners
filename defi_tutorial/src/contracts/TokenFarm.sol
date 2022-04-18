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
    address  public owner;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // Stake tokens
    function stakeTokens(uint _amount) public {
        require(_amount > 0, "amount must be greater than zero");
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


    function issueTokens() public {
        require(msg.sender == owner, "only owner may call this function");
        for(uint i=0; i< stakers.length;i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance > 0) {
            dappToken.transfer(recipient,balance);
            }
            
        }
    }

    function unstakeTokens() public {
        //Fetch balance
        uint balance = stakingBalance[msg.sender];

        require(balance > 0, "staking balance must be greater than zero");

        daiToken.transfer(msg.sender, balance);
        stakingBalance[msg.sender] = 0;
        isStaking[msg.sender] = false;
    }
}
