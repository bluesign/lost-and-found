// This transaction is a template for a transaction
// to add a Vault resource to their account
// so that they can use the exampleToken

import FungibleToken from 0xee82856bf20e2aa6
import ExampleToken from 0xf8d6e0586b0a20c7

transaction {

    prepare(signer: AuthAccount) {

        // Return early if the account already stores a ExampleToken Vault
        if signer.borrow<&ExampleToken.Vault>(from: /storage/exampleTokenVault) != nil {
            return
        }

        // Create a new ExampleToken Vault and put it in storage
        signer.save(
            <-ExampleToken.createEmptyVault(),
            to: /storage/exampleTokenVault
        )

        // Create a public capability to the Vault that only exposes
        // the deposit function through the Receiver interface
        signer.link<&ExampleToken.Vault{FungibleToken.Receiver}>(
            /public/exampleTokenReceiver,
            target: /storage/exampleTokenVault
        )

        // Create a public capability to the Vault that only exposes
        // the balance field through the Balance interface
        signer.link<&ExampleToken.Vault{FungibleToken.Balance}>(
            /public/exampleTokenBalance,
            target: /storage/exampleTokenVault
        )
    }
}