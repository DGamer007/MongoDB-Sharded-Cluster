# Single Machine 3 Shards

# Create Directory Structure

$base = @("store/config","store/shards")
$shards = @("shard1","shard2","shard3")
$nodes = @("node1","node2","node3")

foreach ($node in $nodes){
    $directory = Join-Path $base[0] $node
    New-Item -ItemType Directory -Path $directory

    foreach($shard in $shards){
        $directory = Join-Path $base[1] $shard
        $directory = Join-Path $directory $node
        New-Item -ItemType Directory -Path $directory
    }
}

# Config Server ReplicaSet Nodes
Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --configsvr --port=1001 --dbpath="./store/config/node1" --replSet="configserver-rs"'

Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --configsvr --port=1002 --dbpath="./store/config/node2" --replSet="configserver-rs"'

Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --configsvr --port=1003 --dbpath="./store/config/node3" --replSet="configserver-rs"'

Start-Sleep -Seconds 5

Start-Process powershell -ArgumentList '-NoExit', '-Command', 'mongosh --port=1001 --quiet --shell --norc --file ./config.js configserver-rs'

# Shard1 ReplicaSet Nodes
Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --shardsvr --port=1011 --dbpath="./store/shards/shard1/node1" --replSet="shard1-rs"'

Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --shardsvr --port=1012 --dbpath="./store/shards/shard1/node2" --replSet="shard1-rs"'

Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --shardsvr --port=1013 --dbpath="./store/shards/shard1/node3" --replSet="shard1-rs"'

Start-Sleep -Seconds 5

Start-Process powershell -ArgumentList '-NoExit', '-Command', 'mongosh --port=1011 --quiet --shell --norc --file ./config.js shard1-rs'

# Shard2 ReplicaSet Nodes
Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --shardsvr --port=1021 --dbpath="./store/shards/shard2/node1" --replSet="shard2-rs"'

Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --shardsvr --port=1022 --dbpath="./store/shards/shard2/node2" --replSet="shard2-rs"'

Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --shardsvr --port=1023 --dbpath="./store/shards/shard2/node3" --replSet="shard2-rs"'

Start-Sleep -Seconds 5

Start-Process powershell -ArgumentList '-NoExit', '-Command', 'mongosh --port=1021 --quiet --shell --norc --file ./config.js shard2-rs'

# Shard3 ReplicaSet Nodes
Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --shardsvr --port=1031 --dbpath="./store/shards/shard3/node1" --replSet="shard3-rs"'

Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --shardsvr --port=1032 --dbpath="./store/shards/shard3/node2" --replSet="shard3-rs"'

Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongod --shardsvr --port=1033 --dbpath="./store/shards/shard3/node3" --replSet="shard3-rs"'

Start-Sleep -Seconds 5

Start-Process powershell -ArgumentList '-NoExit', '-Command', 'mongosh --port=1031 --quiet --shell --norc --file ./config.js shard3-rs'

# Mongos Router
Start-Process powershell -ArgumentList '-NoExit', '-Command',
'mongos --port=2000 --configdb="configserver-rs/localhost:1001,localhost:1002,localhost:1003"'

Start-Sleep -Seconds 5

Start-Process powershell -ArgumentList '-NoExit', '-Command', 'mongosh --norc --quiet --port=2000'

# Connect to Individual Shards

Start-Sleep -Seconds 2
Start-Process powershell -ArgumentList '-NoExit', '-Command', 'mongosh --norc --quiet mongodb://localhost:1011,localhost:1012,localhost:1013'

Start-Sleep -Seconds 2
Start-Process powershell -ArgumentList '-NoExit', '-Command', 'mongosh --norc --quiet mongodb://localhost:1021,localhost:1022,localhost:1023'

Start-Sleep -Seconds 2
Start-Process powershell -ArgumentList '-NoExit', '-Command', 'mongosh --norc --quiet mongodb://localhost:1031,localhost:1032,localhost:1033'