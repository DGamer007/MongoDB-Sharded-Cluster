const fs = require('fs');

const configData = JSON.parse(fs.readFileSync('./config.json'));
const replicaSetName = process.argv.splice(8)[0];

if (replicaSetName && Object.keys(configData).includes(replicaSetName)) {
    rs.initiate(configData[replicaSetName]);
} else {
    print("ReplicaSet Name is not Provided");
}