#!/bin/bash
CURRENT_DIR=$(pwd)
EXECUTION_DIR=~/
cd $EXECUTION_DIR \
    && mise self-update \
    && mise upgrade -i \
    && pitchfork supervisor start --force \
&& cd $CURRENT_DIR