# CloudHunter


### Hunter
A ressurector of contracts that selfdestruct() in the void.  The hunter draws an arrow, takes aim at a cloud, and shoots.  An instantaneous flash in the cloud.  Gone as quickly as it is create2ed, but long enough to carry out mission critical intructions.

### Arrow
An arrow made of bytecode that never misses it's intended target.

### Cloud
A smart contract address that's deterministically pre-computed but has no contract deployed to it. Also known as a lazy, counterfactual, wallet contract. It's address is determined in part by both the hunter and the arrow. Tokens, NFT's, and Ether can be sent to this cloud of pure nothingness.

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
contract is create2ed in the cloud which then carries out instructions before selfdestruct()ing

Step 5.
Profit

# Acknowledgements
Cloudhunter was inspired by [Fred's](https://twitter.com/0x66726564) [talk at Solidity Summit 2022](https://www.youtube.com/watch?v=E9usgNS6du0&list=PLX8x7Zj6Vezl1lqBgxiQH3TFbRNZza8Fk&index=6).  I also found Tena Codes [video](https://www.youtube.com/watch?v=ujeeP4wdsao) on this subject to be helpful.
