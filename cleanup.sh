#!/bin/bash

echo "🧹 Starting Docker cleanup..."

# Stop all running containers
echo "Stopping all running containers..."
if [ "$(docker ps -q)" ]; then
    docker stop $(docker ps -q)
    echo "✅ All containers stopped"
else
    echo "ℹ️  No running containers to stop"
fi

# Remove all containers (stopped and running)
echo "Removing all containers..."
if [ "$(docker ps -aq)" ]; then
    docker rm $(docker ps -aq)
    echo "✅ All containers removed"
else
    echo "ℹ️  No containers to remove"
fi

# Remove all images
echo "Removing all images..."
if [ "$(docker images -q)" ]; then
    docker rmi $(docker images -q) -f
    echo "✅ All images removed"
else
    echo "ℹ️  No images to remove"
fi

# Remove all volumes
echo "Removing all volumes..."
if [ "$(docker volume ls -q)" ]; then
    docker volume rm $(docker volume ls -q) -f
    echo "✅ All volumes removed"
else
    echo "ℹ️  No volumes to remove"
fi

# Remove all networks (except default ones)
echo "Removing custom networks..."
if [ "$(docker network ls --filter type=custom -q)" ]; then
    docker network rm $(docker network ls --filter type=custom -q)
    echo "✅ Custom networks removed"
else
    echo "ℹ️  No custom networks to remove"
fi

# Clean up build cache
echo "Cleaning up build cache..."
docker builder prune -af

# Final cleanup
echo "Running final system cleanup..."
docker system prune -af --volumes

echo ""
echo "🎉 Docker cleanup completed!"
echo "📊 Current Docker status:"
echo "Containers: $(docker ps -a --format 'table {{.Names}}\t{{.Status}}' 2>/dev/null | wc -l) (including header)"
echo "Images: $(docker images -q | wc -l)"
echo "Volumes: $(docker volume ls -q | wc -l)"
echo "Networks: $(docker network ls -q | wc -l)"