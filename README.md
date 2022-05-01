# CloudHunter


### Cloud
A smart contract address that's deterministically pre-computed but has no contract deployed to it. Also known as a lazy, counterfactual, wallet contract. Tokens, NFT's, and Ether can be sent to this cloud of pure nothingness.

### Hunter
A ressurector of contracts that selfdestruct() in the void.  The hunter takes aim at a cloud, draws an arrow, and shoots.  An instantaneous flash in the cloud.  Gone as quickly as it is create2ed, but long enough to carry out intructions.

### Arrow
An arrow made of bytecode that never misses it's intended target.

### Quiver
A registry of arrows.

Step 1.
Deploy Quiver

Step 2.
Deploy Hunter

Step 3.
seek() - Based on the hunter's address, the arrow used, and user defined salt, the perfect cloud is found

Step 4.
shoot() - After the user has sent in funds or done whatever is needed with the cloud address, a
contract is create2ed which carries out instructions before selfdestruct()ing.

Step 5.
Profit.