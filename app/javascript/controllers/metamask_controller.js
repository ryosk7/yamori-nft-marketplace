import { Controller } from "@hotwired/stimulus"
import Web3 from "web3"
import { abi, NFTMarketplace_CONTRACT_ADDRESS } from "../contracts/index.js";

// Connects to data-controller="metamask"
export default class extends Controller {
  connect() {
  }

  async signin() {
    const provider = window.ethereum || window.web3?.provider || null

    if (!provider) {
      console.error('!provider')
      return
    }

    const web3 = new Web3(provider)
    const [address] = await web3.eth.requestAccounts()
    const message = 'Connecting Yamori NFT Market. Are you sure?'
    const password = ''
    const signature = await web3.eth.personal.sign(
                              message, address, password
                            )

    const csrfToken = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");

    fetch("http://localhost:3000/user_wallets/", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify({message, address, signature}),
    }).then(response => response.json())
      .then(data => {
        if (data.connected) {
          this.element.style.display = 'none';
        }
      });
  }

  async buyNFT(event) {
    const provider = window.ethereum || window.web3?.provider || null

    if (!provider) {
      console.error('!provider')
      return
    }

    const contractABI = abi;
    const contractAddress = NFTMarketplace_CONTRACT_ADDRESS; 

    const web3 = new Web3(provider)
      
    // スマートコントラクトのインスタンスを作成
    const myContract = new web3.eth.Contract(contractABI, contractAddress);

    const tokenId = event.currentTarget.id
    const accounts = await web3.eth.getAccounts(); // 使用するアカウントの取得
    const senderAddress = accounts[0]; // 送信者のアドレス
    
    const transactionData = myContract.methods.buyNFT(tokenId).encodeABI();
    
    const tx = {
        from: senderAddress,
        to: contractAddress,
        data: transactionData,
        gas: 1000000 // ガスリミット
    };
    
    web3.eth.sendTransaction(tx)
        .then(receipt => {
            console.log('Transaction receipt: ', receipt);
        })
        .catch(error => {
            console.error('Transaction error: ', error);
        });
  }
}
