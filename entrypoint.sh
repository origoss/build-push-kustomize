#!/bin/sh -l

echo "hello $1"
echo "ls /github/workspace"
ls /github/workspace
echo "----- env ------"
printenv
