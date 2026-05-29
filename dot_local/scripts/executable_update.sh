#!/bin/bash
CURRENT_DIR=$(pwd)
EXECUTION_DIR=~/
cd $EXECUTION_DIR && mise self-update && mise upgrade -i && cd $CURRENT_DIR