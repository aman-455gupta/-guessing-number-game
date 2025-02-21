pragma solidity ^0.8.0;

contract NumberGuessingGame {
    address payable public owner;
    uint256 private secretNumber = 7; // Predefined secret number
    uint256 public prizePool;
    mapping(address => uint256) public winnings;
    
    event NumberGuessed(address indexed player, bool success, uint256 amountWon);
    event PrizeWithdrawn(address indexed player, uint256 amount);

    function guessNumber(uint256 _guess) public payable {

        require(msg.value > 0, "Must send Ether to guess");
        prizePool += msg.value;
        
        if (_guess == secretNumber) {
            uint256 prize = prizePool;
            winnings[msg.sender] += prize;
            prizePool = 0;
            emit NumberGuessed(msg.sender, true, prize);
        } else {
            emit NumberGuessed(msg.sender, false, 0);
        }
    }

    function withdrawPrize() public {
        uint256 amount = winnings[msg.sender];
        require(amount > 0, "No winnings to withdraw");
        winnings[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit PrizeWithdrawn(msg.sender, amount);
    }
    
    function getPrizePool() public view returns (uint256) {
        return prizePool;
    }
}
