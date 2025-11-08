#!/bin/bash
set -e
echo "Stopping and removing containers..."
docker-compose down -v

echo "Removing persistent data..."
sudo rm -rf ./data/database ./data/logs ./data/var ./data/redis ./data/certs

echo "Done. Environment wiped clean."
