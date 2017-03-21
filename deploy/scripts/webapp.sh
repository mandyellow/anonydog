#!/usr/bin/env bash

# Usage example:
#     $ ANONYDOG_ENV=arraisbot ./deploy/scripts/webapp.sh

MAIN_SCRIPT=webapp.sh

if [ -z ${ANONYDOG_ENV+x} ]; then
  echo "need ANONYDOG_ENV"
  exit
fi
SCRIPTS_DIR=$(cd "$(dirname "$0")"; pwd)

ENVS_DIR=$(cd "$SCRIPTS_DIR/../envs"; pwd)
BIN_DIR=$(cd "$SCRIPTS_DIR/../../worker"; pwd)
MAIN=$BIN_DIR/$MAIN_SCRIPT

SELECTED_ENV_DIR="$ENVS_DIR/$ANONYDOG_ENV"

read -s -p "Please enter password for $ANONYDOG_ENV environment: " SELECTED_ENV_PASSWORD
echo

GITHUB_API_ACCESS_TOKEN=`openssl enc -aes-256-cbc -d -in $SELECTED_ENV_DIR/github_api_access_token.enc -k $SELECTED_ENV_PASSWORD`
GITHUB_WEBHOOK_SECRET=`openssl enc -aes-256-cbc -d -in $SELECTED_ENV_DIR/github_webhook_secret.enc -k $SELECTED_ENV_PASSWORD`

GITHUB_WEBHOOK_ENDPOINT=`cat $SELECTED_ENV_DIR/github_webhook_endpoint`

# FIXME: ssl and multihost
env GITHUB_API_ACCESS_TOKEN=$GITHUB_API_ACCESS_TOKEN \
    GITHUB_WEBHOOK_SECRET=$GITHUB_WEBHOOK_SECRET \
    GITHUB_WEBHOOK_ENDPOINT=$GITHUB_WEBHOOK_ENDPOINT \
    IP=127.0.0.1 \
    PORT=4000 \
    $MAIN