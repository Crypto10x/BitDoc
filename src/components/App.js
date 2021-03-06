import React, { Component } from 'react'
import './App.css'
import Navbar from './Navbar'
import Web3 from 'web3'
import Token from '../abis/Token.json'
import DcaSwap from '../abis/DcaSwap.json'
import Main from './Main'


class App extends Component {

  async componentWillMount() {
    console.log('starting')
    await this.loadWeb3()
    await this.loadBlockchainData()

  }

  async loadBlockchainData() {
    const web3 = window.web3
    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })

    const ethBalance = await web3.eth.getBalance(this.state.account)
    this.setState({ ethBalance: ethBalance })
    console.log('ETH Balance', this.state.ethBalance)

    const networkId = await web3.eth.net.getId()

    //Load token
    const tokenData = Token.networks[networkId]
    if (tokenData) {
      const token = new web3.eth.Contract(Token.abi, tokenData.address)
      this.setState({ token })
      let tokenBalance = await token.methods.balanceOf(this.state.account).call()

      console.log("tokenBalance", tokenBalance.toString())
      this.setState({ tokenBalance: tokenBalance.toString() })

    } else {
      window.alert('Token contract not deployed to the detected network')
    }

    // Load dca swap
    const dcaData = DcaSwap.networks[networkId]
    if (dcaData) {
      const dcaSwap = new web3.eth.Contract(DcaSwap.abi, dcaData.address)
      this.setState({ dcaSwap })
      // let dcaSwapTokenBalance = await token.methods.balanceOf(dcaData.address).call()
      // console.log('DCA swap token:', dcaSwapTokenBalance.toString())

      let dcaSwapEthBalance = await web3.eth.getBalance(dcaData.address)
      console.log('DCA swap ETH:', dcaSwapEthBalance.toString())
      let rate = await dcaSwap.methods.rate.call().call()
      this.setState({ rate: rate.toString() })
      console.log('rate', rate.toString())

    } else {
      window.alert('Token contract not deployed to the detected network')
    }

    this.setState({ loading: false })
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

  buyTokens = (etherAmount) => {
    this.setState({ loading: true })
    this.state.dcaSwap.methods.buyTokens().send({ value: etherAmount, from: this.state.account }).on('transactionHash', (hash) => {
      this.setState({ loading: false })
      window.location.reload()
    })
  }

  sellTokens = (tokenAmount) => {
    this.setState({ loading: true })
    this.state.token.methods.approve(this.state.dcaSwap.address, tokenAmount).send({ from: this.state.account }).on('transactionHash', (hash) => {
      this.state.dcaSwap.methods.sellTokens(tokenAmount).send({ from: this.state.account }).on('transactionHash', (hash) => {
        this.setState({ loading: false })
        window.location.reload()
      })
    })
  }
  constructor(props) {
    super(props)
    this.state = {
      account: '',
      token: {},
      dcaSwap: {},
      ethBalance: 0,
      tokenBalance: 0,
      loading: true,
      rate: 100
    }
  }

  render() {
    let content
    if (this.state.loading) {
      content = <p id="loader" className="text-center" > Loading ...</p>
    } else {
      content = <Main
        ethBalance={this.state.ethBalance}
        tokenBalance={this.state.tokenBalance}
        buyTokens={this.buyTokens}
        sellTokens={this.sellTokens}
        rate={this.state.rate}

      />
    }
    return (
      <div>
        <Navbar account={this.state.account} />
        <div className="container-fluid mt-5">
          <div className="row">
            <main role="main" className="col-lg-12 ml-auto mr-auto " style={{ maxWidth: '600px' }}>
              <div className="content mr-auto ml-auto">
                {content}
              </div>
            </main>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
