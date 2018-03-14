var account_one = "0x1234..."; // an address
var account_two = "0xabcd..."; // another address

var meta;
StakeAgent.deployed().then(function(instance) {    sa = instance;    eth.sendTransaction({from: '0x627306090abaB3A6e1400e9345bC60c78a8BEf57', to: '0x627306090abaB3A6e1400e9345bC60c78a8BEf57', value: web3.toWei(1, "ether")})})
    .then(function(result) {
    // result is an object with the following values:
    //
    // result.tx      => transaction hash, string
    // result.logs    => array of decoded events that were triggered within this transaction
    // result.receipt => transaction receipt object, which includes gas used

    // We can loop through result.logs to see if we triggered the Transfer event.
    for (var i = 0; i < result.logs.length; i++) {
        var log = result.logs[i];

        if (log.event == "deposit") {
            console.log(log);
            break;
        }
    }
}).catch(function(err) {
    // There was an error! Handle it.
});