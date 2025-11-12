#!/bin/bash

# Simple SCP transfer script
REMOTE_USER="pi"
REMOTE_HOST="192.168.1.66"

# Copy single file
scp $1 "$REMOTE_USER@$REMOTE_HOST:/tmp/picopy.txt"
