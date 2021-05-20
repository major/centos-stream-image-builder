#!/bin/bash
set -euxo pipefail

BLUEPRINT_NAME=centos

# Push the blueprint and depsolve.
composer-cli blueprints push /vagrant/${BLUEPRINT_NAME}-blueprint.toml
composer-cli blueprints depsolve ${BLUEPRINT_NAME} > /dev/null
composer-cli blueprints list

# Start the build.
#composer-cli --json compose start ${BLUEPRINT_NAME} ami image-from-container /repo/aws-config.toml | tee compose_start.json
composer-cli --json compose start ${BLUEPRINT_NAME} ami | tee compose_start.json
COMPOSE_ID=$(jq -r '.build_id' compose_start.json)

# Watch the logs while the build runs.
sudo journalctl -af -n0 &

while true; do
    composer-cli --json compose info "${COMPOSE_ID}" | tee compose_info.json > /dev/null
    COMPOSE_STATUS=$(jq -r '.queue_status' compose_info.json)

    # Is the compose finished?
    if [[ $COMPOSE_STATUS != RUNNING ]] && [[ $COMPOSE_STATUS != WAITING ]]; then
        echo "Compose finished."
        break
    else
        echo "Compose still running..."
    fi
    sleep 30
done

if [[ $COMPOSE_STATUS != FINISHED ]]; then
    composer-cli compose logs ${COMPOSE_ID}
    tar -axf /${COMPOSE_ID}-logs.tar logs/osbuild.log -O
    echo "Something went wrong with the compose. 😢"
    exit 1
fi

# Download the image.
composer-cli compose image ${COMPOSE_ID}
mkdir -vp /vagrant/output
tar -xf /${COMPOSE_ID}-commit.tar -C /vagrant/output/