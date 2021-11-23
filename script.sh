#!/bin/bash
command=$1
target=$2
parameters="${@:3}"
echo "command: " $command # config or image
echo "target:" $target # {directory name} or {image name}
echo "parameters: " $parameters

echo "Running command: trivy $command $parameters $target"
trivy $command $parameters $target
