# MongoDB Sharding (Cluster with 3 Shards, Single Machine)

You can read about MongoDB Replication and Sharding in this [Gist](https://gist.github.com/DGamer007/0864c6aeebf27e3821602d9dd5ca7375).

## Project Overview

The Project Provides utilities to perform **Sharding** on **MongoDB Database** on **Single Machine**. The Project consists of...

- **init.ps1** - Creates Directory Structure for ReplicaSet Nodes, Starts necessary Shells and Initializes Sharded Cluster by performing Basic Configurations which are; Starting mongod Instances and Initiating ReplicaSets

- **start.ps1** - Starts already Initialized Sharded Cluster's Instances and Shells

- **clean.ps1** - Removes ReplicaSet Nodes by deleting Directory structure along with Data

- **config.js** - Script for ReplicaSet Initiation

- **config.json** - Configuration Object for ReplicaSet Initiation

- **data.csv** - Amazon Product Ratings Sample Dataset

### Prerequisites

- **mongod**, **mongosh**, **mongos**, **mongoimport** must be installed and Installation Directory path must be added to _Path Environment variable_

- **Windows Terminal** can be installed and set as Default Terminal Application for Better Experience

## Manual Process for Performing Sharding

### Config Server ReplicaSet Nodes

```bash

# Mongod Instances
mongod --configsvr --port=1001  --replSet="configserver-rs" --dbpath="./store/config/node1"

mongod --configsvr --port=1002  --replSet="configserver-rs" --dbpath="./store/config/node2"

mongod --configsvr --port=1003  --replSet="configserver-rs" --dbpath="./store/config/node3"

# Mongo Shell Connection
mongosh --port=1001

# Initiate ReplicaSet
rs.initiate({
    _id: "configserver-rs",
    configsvr: true,
    members: [
        {_id: 0, host: "localhost:1001"},
        {_id: 1, host: "localhost:1002"},
        {_id: 2, host: "localhost:1003"}
    ]
})

```

### Shard1 ReplicaSet Nodes

```bash

# Mongod Instances
mongod --shardsvr --port=1011 --replSet="shard1-rs" --dbpath="./store/shards/shard1/node1"

mongod --shardsvr --port=1012 --replSet="shard1-rs" --dbpath="./store/shards/shard1/node2"

mongod --shardsvr --port=1013 --replSet="shard1-rs" --dbpath="./store/shards/shard1/node3"

# Mongo Shell Connection
mongosh --port=1011

# Initiate ReplicaSet
rs.initiate({
    _id: "shard1-rs",
    members: [
        {_id: 0, host: "localhost:1011"},
        {_id: 1, host: "localhost:1012"},
        {_id: 2, host: "localhost:1013"},
    ]
})

```

### Shard2 ReplicaSet Nodes

```bash

# Mongod Instances
mongod --shardsvr --port=1021 --replSet="shard2-rs" --dbpath="./store/shards/shard2/node1"

mongod --shardsvr --port=1022 --replSet="shard2-rs" --dbpath="./store/shards/shard2/node2"

mongod --shardsvr --port=1023 --replSet="shard2-rs" --dbpath="./store/shards/shard2/node3"

# Mongo Shell Connection
mongosh --port=1021

# Initiate ReplicaSet
rs.initiate({
    _id: "shard2-rs",
    members: [
        {_id: 0, host: "localhost:1021"},
        {_id: 1, host: "localhost:1022"},
        {_id: 2, host: "localhost:1023"},
    ]
})

```

### Shard3 ReplicaSet Nodes

```bash

# Mongod Instances
mongod --shardsvr --port=1031 --replSet="shard3-rs" --dbpath="./store/shards/shard3/node1"

mongod --shardsvr --port=1032 --replSet="shard3-rs" --dbpath="./store/shards/shard3/node2"

mongod --shardsvr --port=1033 --replSet="shard3-rs" --dbpath="./store/shards/shard3/node3"

# Mongo Shell Connection
mongosh --port=1031

# Initiate ReplicaSet
rs.initiate({
    _id: "shard3-rs",
    members: [
        {_id: 0, host: "localhost:1031"},
        {_id: 1, host: "localhost:1032"},
        {_id: 2, host: "localhost:1033"},
    ]
})

```

### Mongos Router

```bash

# Mongos Instance
mongos --port=2000 --configdb="configserver-rs/localhost:1001,localhost:1002,localhost:1003"

# Mongo Shell Connection
mongosh --port=2000

# Add Shards
sh.addShard("shard1-rs/localhost:1011,localhost:1012,localhost:1013")
sh.addShard("shard2-rs/localhost:1021,localhost:1022,localhost:1023")
sh.addShard("shard3-rs/localhost:1031,localhost:1032,localhost:1033")

# Enable Sharding on a Database (Optional)
sh.enableSharding("amazon")

# Shard a Collection
sh.shardCollection("amazon.reviews",{ userid: "hashed", productid: 1})

```

### Import Data into Cluster

```bash

mongoimport --type=csv --headerline --uri="mongodb://localhost:2000/amazon" --collection="reviews" --file="./data.csv"

```

### Connect to Individual Shard-ReplicaSets

```bash

# Shard1
mongosh mongodb://localhost:1011,localhost:1012,localhost:1013/amazon

# Shard2
mongosh mongodb://localhost:1021,localhost:1022,localhost:1023/amazon

# Shard3
mongosh mongodb://localhost:1031,localhost:1032,localhost:1033/amazon

```
