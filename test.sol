pragma solidity ^0.4.19;
contract example {
address contractOwner;
function example() {
contractOwner = msg.sender;
}
}
