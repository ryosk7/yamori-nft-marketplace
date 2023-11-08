import { Controller } from "@hotwired/stimulus"
import Web3 from "web3"

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
}
