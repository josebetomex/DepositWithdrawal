pragma solidity >=0.4.25 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DepositWithdrawal.sol";

contract TestDepositWithdrawal {

  function testInitialBalanceUsingDeployedContract() public {
    DepositWithdrawal meta = DepositWithdrawal(DeployedAddresses.DepositWithdrawal());

    uint expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 initially");
  }

 

}
