
pragma solidity ^0.4.21;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}




interface token {
    function transfer(address receiver, uint amount);
}


contract Crowdsale {
    using SafeMath for uint256;

    address public beneficiary = /**/;
    uint public price = etherCostOfEachToken * 1 ether;;
    token public tokenReward = token(/**/);
    uint public amountRaised;
    bool public adminVer = false;
    mapping(address => uint256) public balanceOf;
    bool public crowdsaleClosed = false;

    event FundTransfer(address backer, uint amount, bool isContribution);


    modifier onlyOwner {require(msg.sender == beneficiary); _;}

    /**
    * Check ownership
    */
    function checkAdmin() onlyOwner {
        adminVer = true;
    }

    /**
     * Transfer ownership
     *
     * Change admin wallet
     *
     * @param newOwner is address of new admin wallet
     */
    function transferOwnership(address newOwner) onlyOwner {
        beneficiary = newOwner;
        adminVer = false;
    }

    /**
     * Return unsold tokens to beneficiary address
     */
    function getUnsoldTokens(uint val_) onlyOwner {
        tokenReward.transfer(beneficiary, val_);
    }

    /**
     * Return unsold tokens to beneficiary address with decimals
     */
    function getUnsoldTokensWithDecimals(uint val_, uint dec_) onlyOwner {
        val_ = val_ * 10 ** dec_;
        tokenReward.transfer(beneficiary, val_);
    }

    /**
     * Change crowdsale discount stage
     */
    function changePrice(uint256 newPerice) onlyOwner {
        price = newPerice;
    }

    /**
     * Close/Open crowdsale
     */
    function closeCrowdsale(bool closeType) onlyOwner {
        crowdsaleClosed = closeType;
    }


    /**
     * Fallback function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract
     */
    function () payable {
        require(!crowdsaleClosed);
        uint256 amount = msg.value;
        balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
        amountRaised = amountRaised.add(amount);
        tokenReward.transfer(msg.sender, amount.div(price));
        FundTransfer(msg.sender, amount, true);
        if (beneficiary.send(amount)) { FundTransfer(beneficiary, amount, price, false); } //send users amount to beneficiary
    }

}
