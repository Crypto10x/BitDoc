const { default: Web3 } = require('web3')
const Token = artifacts.require('Token')
const DcaSwap = artifacts.require('DcaSwap')


require('chai')
    .use(require('chai-as-promised'))
    .should()
function tokens(n){
    return web3.utils.toWei(n,'ether');
}
contract('DcaSwap',([deployer,investor])=>{
    let token,dcaSwap
    before( async() => {
        token = await Token.new()
        dcaSwap = await DcaSwap.new(token.address)
         // Transfer all tokens to dcaswap (1 million)
        await token.transfer(dcaSwap.address,tokens('1000000'))
    })

    describe('Token deployement',async()=>{
        it('contract has a name', async()=>{
            const name = await token.name()
            assert.equal(name,'DCA token')
        })
    })

    describe('DcaSwap deployement',async()=>{
        it('contract has a name', async()=>{

            const name = await dcaSwap.name()
            assert.equal(name,'Dollar Cost Averaging Crypto Asset')
        })
        
        it('contract has tokens', async()=>{
            let balance = await token.balanceOf(dcaSwap.address)
            assert.equal(balance.toString(),tokens('1000000'))

        })
    })

    describe('buyTokens()', async()=>{
        let result
        before(async ()=>{
            //Purchase token before each example
            result = await dcaSwap.buyTokens({from:investor,value:web3.utils.toWei('1','ether')})
        })

        it('allow user to purchase token for fix price', async() =>{
            // Check investor balance after purchase
            let investorBalance = await token.balanceOf(investor)
            assert.equal(investorBalance.toString(),tokens('100'))
            let dcaSwapBalance
            dcaSwapBalance = await token.balanceOf(dcaSwap.address)
            assert.equal(dcaSwapBalance.toString(),tokens('999900'))
            dcaSwapBalance = await web3.eth.getBalance(dcaSwap.address)
            assert.equal(dcaSwapBalance.toString(),web3.utils.toWei('1','Ether'))

            //console.log(result)
            const event = result.logs[0].args
            assert.equal(event.account,investor)
            assert.equal(event.token,token.address)
            assert.equal(event.amount.toString(),tokens('100').toString())
            assert.equal(event.rate.toString(),'100')
        })
    })

    describe('sellTokens()', async()=>{
        let result
        before(async ()=>{
            // Investor must approve tokens before the purchase
            await token.approve(dcaSwap.address,tokens('100'),{from: investor})
            // Investor sells token
            result = await dcaSwap.sellTokens(tokens('100'),{from: investor})
        })

        it('allow user to sell token to dca swap for fix price', async() =>{
            let investorBalance = await token.balanceOf(investor)
            //check investor token after sell
            assert.equal(investorBalance.toString(),tokens('0'))

            //check ethSwap balance after sell
            let dcaSwapBalance 
            dcaSwapBalance = await token.balanceOf(dcaSwap.address)
            assert.equal(dcaSwapBalance.toString(),tokens('1000000'))

            dcaSwapBalance = await web3.eth.getBalance(dcaSwap.address)
            assert.equal(dcaSwapBalance.toString(),web3.utils.toWei('0','Ether'))

            //check logs to ensure event was emitted with correct data
            const event = result.logs[0].args
            assert.equal(event.account,investor)
            assert.equal(event.token,token.address)
            assert.equal(event.amount.toString(),tokens('100').toString())
            assert.equal(event.rate.toString(),'100')
            
            // FAILURE: investor can't sell more tokens than they have
            await dcaSwap.sellTokens(tokens('500'),{from: investor}).should.be.rejected;
        })

    
    })
})
