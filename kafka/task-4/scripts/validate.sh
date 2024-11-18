#!/bin/bash

CONFIG_TOPICS=$1
CONFIG_PERMISSIONS=$2

if ! yq eval '.' "$CONFIG_TOPICS" > /dev/null 2>&1; then
  echo "Invalid topics YAML file: $CONFIG_TOPICS"
  exit 1
fi

if ! yq eval '.' "$CONFIG_PERMISSIONS" > /dev/null 2>&1; then
  echo "Invalid permissions YAML file: $CONFIG_PERMISSIONS"
  exit 1
fi

echo "Validation passed for $CONFIG_TOPICS"
