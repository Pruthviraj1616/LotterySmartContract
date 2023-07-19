// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery{

    address public Manager;
    address payable[] Players;

    constructor() {
        Manager=(msg.sender);
    }    
    function AlreadyExistplayer() private view returns(bool) {
        for (uint i;i < Players.length; i++)
        {
            if (Players[i]==msg.sender)
            return true;           
        }
        return false;
    }

    function ApplyForLottery() public payable {
        require(msg.sender != Manager,"Manager Cannot Apply For Lottery");
        require(AlreadyExistplayer() == false,"You Already Applied For Lottery");
        require(msg.value >= 4 ether,"Minimum Amount Must Be Payed 4 ether");

        Players.push(payable(msg.sender));
    } 

    function random() private view returns(uint) {
        return uint(sha256(abi.encodePacked(block.difficulty,block.number,Players)));
    }

     // Variables for getting value for function-WINNER_IS()
    bool Winner;
    address Winner_Address;

    function PickWinner() public{
        require(msg.sender==Manager,"Only Manager Can Choose Winner");        
        address ContractAddress = address(this);
        uint index=random()%Players.length;//Winner Index
        Players[index].transfer(ContractAddress.balance);
        Winner_Address=Players[index];
        Winner=true;
        Players = new address payable[](0);
    }
    function getPlayers() public view returns(uint,address payable[] memory){
        return (Players.length,Players);
    }

    function WINNER_IS() public view returns(address){
        require(Winner != false,"Winner is not selected");
        return (Winner_Address);
    }
}