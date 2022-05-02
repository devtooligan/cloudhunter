# CloudHunter
```
                                             |
                                              \.
                                              /|.
                                            /  `|.
                                          /      .
                                        /        |.                       (`  ).        .')        _
                                      /          `|.                     (     ).      (_  )   .:(`  )`.
                                    /             |.                    _(       '`.          :(   .    )
                                  /               |.                .=(`(      .   )     .--  `.  (    ) )
               ^^^^^^^          /                 `|.              ((    (..__.:'-'   .+(   )   ` _`  ) )
              /       \       /                    |.              `(       ) )       (   .  )     (   )  ._
             /|      ` \    /                      |.                ` __.:'   )     (   (   ))     `-'.-(`  )
       _____/ =       =|__/___                     |.                       --'       `- __.(`        :(  (   ))
   ,--' ,----`-,__ ___/'  --,-`-===================##===>   _______ _                 _               `( (_.'
 \                '        ##_______ ______   _____##,__   (_______) |               | |   .')    .').  `
   `,    __==    ___,-,__,--'#'  ==='     .`-'   | ##,-/    _      | | ___  _   _  __| |  (_  )  (_  )
     `-,____,---'       \####\            ____,--\_##,/    | |     | |/ _ \| | | |/ _  |    ..=(`:'-'
         #_         I    |##   \  _____,--         ##      | |_____| | |_| | |_| ( (_| |    ((  )
          #         ♥    ]===--==\                 ||       \______)\_)___/|____/ \____|     (   )
          #,      CLOUDS ]         \               ||                       _     _            -'
           #_            |           \            ,|.                      (_)   (_)             _
            ##_       __/'             \          |.                        _______ _   _ ____ _| |_ _____  ____
             ####='     |                \       ,|.                       |  ___  | | | |  _ (_   _) ___ |/ ___)
              ###       |                  \\    |.                        | |   | | |_| | | | || |_| ____| |
              ##       _'                    \\  |.                        |_|   |_|____/|_| |_| \__)_____)_|
             ###=======]                       \\|.
            ///        |                        /.
            //         |                       |
```

### Hunter
A ressurector of contracts that selfdestruct() in the void.  The Hunter draws an Arrow, takes aim at a Cloud, and shoots.  An instantaneous flash in the Cloud, gone as quickly as it is create2ed, but long enough to carry out mission critical intructions.

### Arrow
An arrow made of bytecode that never misses it's intended target.

### Cloud
A smart contract address that's deterministically pre-computed but has no contract deployed to it. Also known as a lazy, counterfactual, wallet contract. It's address is determined in part by both the Hunter and the Arrow. Tokens, NFT's, and Ether can be sent to this Cloud of pure nothingness.

### Quiver
A registry of Arrows.

Step 1.
Deploy Quiver.

Step 2.
Deploy Hunter.

Step 3.
seek() - Based on the Hunter's address, the Arrow used, and user defined salt, the perfect Cloud is found.

Step 4.
shoot() - After the user has sent in funds or done whatever is needed with the cloud address, a
contract is create2ed in the cloud which then carries out instructions before selfdestruct()ing.

Step 5.
Profit.

# Acknowledgements
CloudHunter was inspired by [Fred's](https://twitter.com/0x66726564) [talk at Solidity Summit 2022](https://www.youtube.com/watch?v=E9usgNS6du0&list=PLX8x7Zj6Vezl1lqBgxiQH3TFbRNZza8Fk&index=6).  I also found Tena Codes [video](https://www.youtube.com/watch?v=ujeeP4wdsao) on this subject to be helpful.
