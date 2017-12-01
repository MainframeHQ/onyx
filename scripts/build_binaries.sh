#!/usr/bin/env bash

set -x

COMMIT_HASH=5c8bb8adb87d2977976efc05c9a44bfccafc3188
ROOT_DIR=$(pwd)
BIN_DIR=$ROOT_DIR/bin
TMP_DIR=$ROOT_DIR/tmp

TARGETS=linux/amd64,darwin/amd64,windows/amd64

mkdir $BIN_DIR -p
mkdir $TMP_DIR -p

if [[ ! -e $TMP_DIR/go-ethereum ]]; then
    cd $TMP_DIR
    echo "cloning the go-ethereum repo"
    git clone --depth 1 git@github.com:thusfresh/go-ethereum.git -b mainframe
fi

cd $TMP_DIR/go-ethereum

git fetch --depth 1 origin $COMMIT_HASH
git checkout $COMMIT_HASH

./build/env.sh go run build/ci.go xgo -- --go=latest --targets=$TARGETS -v ./cmd/geth
./build/env.sh go run build/ci.go xgo -- --go=latest --targets=$TARGETS -v ./cmd/swarm

cp build/bin/geth-linux-* $BIN_DIR/geth-linux
cp build/bin/geth-darwin-* $BIN_DIR/geth-mac
cp build/bin/geth-windows-* $BIN_DIR/geth-win
cp build/bin/swarm-linux-* $BIN_DIR/swarm-linux
cp build/bin/swarm-darwin-* $BIN_DIR/swarm-mac
cp build/bin/swarm-windows-* $BIN_DIR/swarm-win

set +x