pragma solidity ^0.4.18;

contract Owned {
  address public owner;

  modifier onlyOwner {
    require(owner == msg.sender);
    _;
  }

  /* Initialise contract creator as owner */
  function Owned() public {
    owner = msg.sender;
  }

  /* Transfer ownership of this contract to someone else */
  function transferOwnership(address newOwner) public onlyOwner() {
    owner = newOwner;
  }
}
